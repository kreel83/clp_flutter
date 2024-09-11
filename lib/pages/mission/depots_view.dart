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
import '../../globals.dart' as globals;

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
  List<bool> isSelected = [];
  bool afficheCirclesAll = false;
  PersistentBottomSheetController? _bottomSheetController;

  ////////////////////////////////

  Future<List<Depot>> getDeps(mission) async {
    var missions = await DepotsService().getDepots(mission);
    return missions;
  }

  Future<void> _pickMultiImage(state) async {
    print('state : '+state.toString());
    
    
      final List<XFile> selectedImages = (await imagePicker.pickMultiImage()).cast<XFile>();
      if (state) {
        setState(() {
          imageFileList = [];
          afficheCircles = [];
          isSelected = [];
        });        
      }

        if (selectedImages.isNotEmpty) {
          setState(() {
            for (XFile element in selectedImages) {
              bool isDuplicate = imageFileList!.any((existingElement) => existingElement.path == element.path);
              if (!isDuplicate) {
                imageFileList!.add(element);
                afficheCircles.add(false);
                isSelected.add(true);
              }
            }
          });
        }
 
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

  Future<void> _pickImage(BuildContext context) async {
    var state =
        await takePicture(widget.mission, widget.collecte, 'depots', context);
    print('state : ' + state.toString());
    if (state) {
      await getDeps(widget.mission).then((value) {
        setState(() {
          depots = value;
          isLoading = false;
        });
        Alert.showToast('Document ajouté avec succés');
      });
    } else {
      // ignore: use_build_context_synchronously
    }
  }

  void _showBottomSheet(BuildContext context) {
    _bottomSheetController = Scaffold.of(context).showBottomSheet(
      (context) {
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
                title: const Text("A partir de l'appareil photo",
                    style: TextStyle(color: Colors.white)),
                onTap: () async {
                  _bottomSheetController!.close();
                  _pickImage(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo,
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
                      final int? result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageUpload(
                              typeDepot: 'depots',
                              idMission: widget.mission,
                              idCollecte: widget.collecte,
                              imageFileList: imageFileList,
                              afficheCircles: afficheCircles,
                              isSelected: isSelected,                              
                              indexTab: 1,
                              pickMultiImage: _pickMultiImage
                              ),
                        ),
                      );
                      if (result == null) {
                        setState(() {
                              imageFileList = [];
                              afficheCircles = [];
                              isSelected = [];                          
                        });
                      }

                      if (result != null && result == 1) {
                        setState(() async {
                          await getDeps(widget.mission).then((value) {
                            setState(() {
                              depots = value;
                              isLoading = false;

                            });
                          });
                        });
                      }
                    }
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: widget.mission.statut == "encours"
            ? FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  _showBottomSheet(context);
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
