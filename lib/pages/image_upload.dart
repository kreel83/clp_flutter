// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:clp_flutter/pages/mission_page.dart';
import 'package:clp_flutter/utils/message.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../../globals.dart' as globals;
import '../utils/alert.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ImageUpload extends StatefulWidget {
  ImageUpload(
      {super.key,
      required this.typeDepot,
      required this.idMission,
      required this.idCollecte,
      required this.imageFileList,
      required this.afficheCircles,
      required this.indexTab});

  var imageFileList;
  final afficheCircles;
  final typeDepot;
  final idMission;
  final idCollecte;
  final indexTab;

  @override
  // ignore: library_private_types_in_public_api
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  // late Future<XFile?> _imageFile;

  // late List<XFile>? imageFileList = [];
  // final ImagePicker imagePicker = ImagePicker();
  // List<bool> afficheCircles = [];
  bool afficheCirclesAll = false;

  // Future<void> _pickMultiImage() async {
  //   final List<XFile> selectedImages =
  //       (await imagePicker.pickMultiImage()).cast<XFile>();
  //   if (selectedImages.isNotEmpty) {
  //     imageFileList!.addAll(selectedImages);
  //   }
  //   setState(() {
  //     // ignore: unused_local_variable
  //     for (XFile element in selectedImages) {
  //       afficheCircles.add(false);
  //     }
  //   });
  // }

  // Future<void> _pickImage() async {
  //   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     setState(() {
  //       _imageFile = Future.value(XFile(pickedFile.path));
  //     });
  //   }
  // }

  sendImageToAPI(List<XFile> imageFile, typeDepot, mission) async {
    var uri = Uri.parse(
        'https://www.la-gazette-eco.fr/api/clp/mission/setPicture'); // Replace with your API endpoint
    var index = 0;
    for (XFile e in widget.imageFileList!) {
      var request = http.MultipartRequest('POST', uri);

      request.headers['authorization'] = 'Bearer ${globals.token}';
      request.headers['Content-Type'] = 'image/jpeg';
      request.fields['type'] = typeDepot;
      request.fields['mission'] = mission.id.toString();
      var bytes = File(e.path).readAsBytesSync();
      request.fields['image'] = base64Encode(bytes);
      setState(() {
        widget.afficheCircles[index] = true;
      });
      try {
        var response = await request.send();
        await http.Response.fromStream(response);
        if (response.statusCode == 200) {
          setState(() {
            widget.afficheCircles[index] = false;
          });
        } else {
          //print('Failed to upload image. Status code: ${response.statusCode}');
        }
      } catch (e) {
        //print('Error uploading image: $e');
      }
      index++;
    }
  }

  sendImageToAPISolo(List<XFile> imageFile, typeDepot, mission, index) async {
    var uri = Uri.parse(
        'https://www.la-gazette-eco.fr/api/clp/mission/setPicture'); // Replace with your API endpoint

    XFile e = widget.imageFileList![index];
    var request = http.MultipartRequest('POST', uri);

    setState(() {
      widget.afficheCircles[index] = true;
    });
    request.headers['authorization'] = 'Bearer ${globals.token}';
    request.headers['Content-Type'] = 'image/jpeg';
    request.fields['type'] = typeDepot;
    request.fields['mission'] = mission.id.toString();
    var bytes = File(e.path).readAsBytesSync();
    request.fields['image'] = base64Encode(bytes);
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        setState(() {
          widget.afficheCircles[index] = false;
        });
      } else {
        //print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      //print('Error uploading image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Liste des documents'),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    afficheCirclesAll = true;
                  });
                  sendImageToAPI(widget.imageFileList!, widget.typeDepot,
                      widget.idMission);
                },
                icon: const Icon(Icons.import_export))
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget.imageFileList == null ||
                            widget.imageFileList!.isEmpty
                        ? const CenterMessageWidget(
                            texte:
                                'Aucun document sélectionné\n cliquez sur + pour ajouter un document')
                        : GridView.builder(
                            itemCount: widget.imageFileList!.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8),
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onLongPress: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                        height: 200,
                                        child: Column(
                                          children: <Widget>[
                                            ListTile(
                                              leading: const Icon(Icons.share),
                                              title: const Text('Télécharger'),
                                              onTap: () async {
                                                await sendImageToAPISolo(
                                                    widget.imageFileList!,
                                                    widget.typeDepot,
                                                    widget.idMission,
                                                    index);

                                                Navigator.push(
                                                  // ignore: use_build_context_synchronously
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MissionPage(
                                                              mission: widget
                                                                  .idMission,
                                                              collecte: widget
                                                                  .idCollecte,
                                                              defaultIndex: widget
                                                                  .indexTab)),
                                                );
                                                Alert.showToast(
                                                    "Document téléchargé avec succès");
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(Icons.delete),
                                              title: const Text('Supprimer'),
                                              onTap: () {
                                                setState(() {
                                                  widget.imageFileList!
                                                      .removeAt(index);
                                                  widget.afficheCircles
                                                      .removeAt(index);
                                                });
                                                // Action pour supprimer
                                                Navigator.pop(context);
                                                Alert.showToast(
                                                    "Image retirée avec succès");
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Opacity(
                                      opacity: (!widget.afficheCircles[index] &&
                                              afficheCirclesAll)
                                          ? 0.5
                                          : 1,
                                      child: Image.file(
                                        File(widget.imageFileList![index].path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    if (widget.afficheCircles[index])
                                      const CircularProgressIndicator()
                                  ],
                                ),
                              );
                            })),
              ),
            ],
          ),
        ));
  }
}
