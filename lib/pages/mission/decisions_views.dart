// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:clp_flutter/pages/image_upload.dart';
import 'package:clp_flutter/pages/photo_page.dart';
import 'package:clp_flutter/utils/alert.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/depot.dart';
import '../../services/depots_service.dart';
import '../../utils/photo.dart' as photos;
import '../../globals.dart' as globals;

class DecisionsView extends StatefulWidget {
  const DecisionsView(
      {super.key,
      required this.mission,
      required this.collecte,
      required this.onItemTapped});

  final mission;
  final collecte;
  final Function(int) onItemTapped;

  @override
  State<DecisionsView> createState() => _DecisionsViewState();
}

class _DecisionsViewState extends State<DecisionsView> {
  String base64Image = "";
  List<Depot> decisions = [];
  bool isLoading = true;
  ///////////////////////
  late List<XFile>? imageFileList = [];
  final ImagePicker imagePicker = ImagePicker();
  List<bool> afficheCircles = [];
  List<bool> isSelected = [];
  bool afficheCirclesAll = false;
  ////////////////////////////////

  Future<List<Depot>> getDeps(mission) async {
    var missions = await DepotsService().getDecisions(mission);
    return missions;
  }


  Future<void> _pickMultiImage() async {
    imageFileList!.clear();
    final List<XFile> selectedImages =
        (await imagePicker.pickMultiImage()).cast<XFile>();
    if (selectedImages.isNotEmpty) {
      setState(() {
        imageFileList!.addAll(selectedImages);
        for (XFile element in selectedImages) {
          afficheCircles.add(false);
          isSelected.add(true);
        }
      });
    }

  }

  @override
  void initState() {
    super.initState();
    getDeps(widget.mission).then((value) {
      setState(() {
        decisions = value;
        isLoading = false;
      });
    });
  }

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
                      return Container(
                        height: 200,
                        decoration: BoxDecoration(color: globals.mainColor),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                              title: const Text(
                                "A partir de l'appareil photo",
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: () async {
                                var state = await photos.takePicture(
                                    widget.mission,
                                    widget.collecte,
                                    'decisions',
                                    context);
                                if (state) {
                                  await getDeps(widget.mission).then((value) {
                                    setState(() {
                                      decisions = value;
                                      isLoading = false;
                                    });
                                  });
                                  Alert.showToast(
                                      'Document ajouté avec succés');
                                } else {
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                }
                              },
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                              title: const Text(
                                "A partir de la gallerie photo",
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                _pickMultiImage(true).then((value) async {
                                  if (imageFileList!.isEmpty) {
                                    Navigator.pop(context);
                                  } else {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ImageUpload(
                                            typeDepot: 'decisions',
                                            idMission: widget.mission,
                                            idCollecte: widget.collecte,
                                            imageFileList: imageFileList,
                                            afficheCircles: afficheCircles,
                                            isSelected: isSelected,
                                            indexTab: 2,
                                            pickMultiImage: _pickMultiImage
                                            ),
                                      ),
                                    ).then((onValue) async {
                                      if (onValue == true) {
                                        await getDeps(widget.mission)
                                            .then((value) {
                                          setState(() {
                                            decisions = value;
                                            isLoading = false;
                                          });
                                          Alert.showToast(
                                              'Document(s) ajouté(s) avec succés');
                                        });
                                      } else {
                                        Alert.showToast(
                                            "L'action a été annulée");
                                      }
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
            : decisions.isEmpty
                ? const Center(
                    child: Text('En attente'),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: decisions.length,
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
                                    depot: decisions[index],
                                    indexTab: 2),
                              ),
                            );
                            setState(() {
                              // print('deleted file');
                            });
                          },
                          leading: const Icon(FontAwesomeIcons.envelope),
                          title: Text(decisions[index].documentName!),
                        ),
                      );
                    }));
  }
}
