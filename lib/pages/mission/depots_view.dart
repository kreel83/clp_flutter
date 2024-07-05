// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:clp_flutter/pages/image_upload.dart';
import 'package:clp_flutter/pages/photo_page.dart';
import 'package:clp_flutter/utils/alert.dart';
import 'package:clp_flutter/utils/photo.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/depots_service.dart';
import 'package:clp_flutter/models/depot.dart';

class DepotsView extends StatefulWidget {
  const DepotsView(
      {super.key,
      required this.mission,
      required this.collecte,
      required this.onItemTapped});

  final mission;
  final collecte;
  final Function(int) onItemTapped;

  @override
  State<DepotsView> createState() => _DepotsViewState();
}

class _DepotsViewState extends State<DepotsView> {
  String base64Image = "";
  get http => null;
  List<Depot> depots = [];
  bool isLoading = true;
  ///////////////////////
  late List<XFile>? imageFileList = [];
  final ImagePicker imagePicker = ImagePicker();
  List<bool> afficheCircles = [];
  bool afficheCirclesAll = false;

  ////////////////////////////////

  Future<List<Depot>> getDeps(mission) async {
    var missions = await DepotsService().getDepots(mission);
    return missions;
  }

  Future<void> _pickMultiImage() async {
    final List<XFile> selectedImages =
        (await imagePicker.pickMultiImage()).cast<XFile>();
    if (selectedImages.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {
      // ignore: unused_local_variable
      for (XFile element in selectedImages) {
        afficheCircles.add(false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getDeps(widget.mission).then((value) {
      setState(() {
        depots = value;
        isLoading = false;
      });
    });
  }

  // getDeps(widget.mission);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: widget.mission.statut == "encours"
            ? FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 200,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text("A partir de l'appareil photo"),
                              onTap: () async {
                                setState(() {
                                  depots = [];
                                  Navigator.pop(context);
                                  isLoading = true;
                                });
                                var state = await takePicture(widget.mission,
                                    widget.collecte, 'depots', context);
                                if (state) {
                                  await getDeps(widget.mission).then((value) {
                                    setState(() {
                                      depots = value;
                                      isLoading = false;
                                    });
                                  });
                                } else {
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                }
                                Alert.showToast('Document ajouté avec succés');
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.browse_gallery),
                              title:
                                  const Text("A partir de la gallerie photo"),
                              onTap: () {
                                _pickMultiImage().then((value) async {
                                  final int? result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImageUpload(
                                          typeDepot: 'depots',
                                          idMission: widget.mission,
                                          idCollecte: widget.collecte,
                                          imageFileList: imageFileList,
                                          afficheCircles: afficheCircles,
                                          indexTab: 1),
                                    ),
                                  );
                                  if (result != null && result == 1) {
                                    setState(() async {
                                      await getDeps(widget.mission)
                                          .then((value) {
                                        setState(() {
                                          depots = value;
                                          isLoading = false;
                                        });
                                      });
                                    });
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              )
            : null,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : depots.isEmpty
                ? const Center(
                    child: Text('En attente'),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: depots.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhotoPage(
                                    mission: widget.mission,
                                    collecte: widget.collecte,
                                    depot: depots[index],
                                    indexTab: 1),
                              ),
                            );
                            setState(() {
                              // print('deleted file');
                            });
                          },
                          leading: const Icon(FontAwesomeIcons.envelope),
                          title: Text(depots[index].documentName!),
                        ),
                      );
                    }));
  }
}
