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
      required this.isSelected,
      required this.indexTab});

  var imageFileList;
  final afficheCircles;
  final isSelected;
  final typeDepot;
  final idMission;
  final idCollecte;
  final indexTab;

  @override
// ignore: library_private_types_in_public_api
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  bool afficheCirclesAll = false;
  bool isRecord = false;

  sendImageToAPI(List<XFile> imageFile, typeDepot, mission, isSelected) async {
    var uri = Uri.parse(
        'https://www.la-gazette-eco.fr/api/clp/mission/setPicture'); // Replace with your API endpoint
    var index = 0;
    for (XFile e in widget.imageFileList!) {
      if (isSelected[index]) {
        var request = http.MultipartRequest('POST', uri);

        request.headers['authorization'] = 'Bearer ${globals.token}';
        request.headers['Content-Type'] = 'image/jpeg';
        request.fields['type'] = typeDepot;
        request.fields['mission'] = mission.id.toString();
        var bytes = File(e.path).readAsBytesSync();
        request.fields['image'] = base64Encode(bytes);
        setState(() {
          widget.afficheCircles[index] = true;
          widget.isSelected[index] = true;
        });
        try {
          var response = await request.send();
          await http.Response.fromStream(response);
          if (response.statusCode == 200) {
            setState(() {
              widget.afficheCircles[index] = false;
              widget.isSelected[index] = false;
            });
          } else {
            //print('Failed to upload image. Status code: ${response.statusCode}');
          }
        } catch (e) {
          //print('Error uploading image: $e');
        }
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
      widget.isSelected[index] = true;
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
          widget.isSelected[index] = false;
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

  bool _condition = false; // Condition que vous souhaitez vérifier

  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Attention'),
          content: const Text(
            "Aucune photo n'a été téléchargé\n Voulez vous vraiment quitter cette page ?",
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Non'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Quitter'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        if (isRecord) {
          Navigator.pop(context);
        } else {
          final bool shouldPop = await _showBackDialog() ?? false;
          if (context.mounted && shouldPop) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Liste des documents'),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      afficheCirclesAll = true;
                      isRecord = true;
                    });
                    sendImageToAPI(widget.imageFileList!, widget.typeDepot,
                        widget.idMission, widget.isSelected);
                  },
                  icon: const Icon(Icons.import_export)),
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
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: GridView.builder(
                                      itemCount: widget.imageFileList!.length,
                                      padding: EdgeInsets
                                          .zero, // Supprime le padding autour du grid
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            2, // Nombre de colonnes dans le grid
                                        crossAxisSpacing:
                                            2.0, // Espacement horizontal entre les cellules
                                        mainAxisSpacing:
                                            2.0, // Espacement vertical entre les cellules
                                        childAspectRatio:
                                            1.0, // Pour que les cellules soient carrées
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              widget.isSelected[index] =
                                                  !widget.isSelected[index];
                                            });
                                          },
                                          onLongPress: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SizedBox(
                                                  height: 200,
                                                  child: Column(
                                                    children: <Widget>[
                                                      ListTile(
                                                        leading: const Icon(
                                                            Icons.share),
                                                        title: const Text(
                                                            'Télécharger'),
                                                        onTap: () async {
                                                          await sendImageToAPISolo(
                                                              widget
                                                                  .imageFileList!,
                                                              widget.typeDepot,
                                                              widget.idMission,
                                                              index);

                                                          Navigator.push(
                                                            // ignore: use_build_context_synchronously
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => MissionPage(
                                                                    mission: widget
                                                                        .idMission,
                                                                    collecte: widget
                                                                        .idCollecte,
                                                                    defaultIndex:
                                                                        widget
                                                                            .indexTab)),
                                                          );
                                                          Alert.showToast(
                                                              "Document téléchargé avec succès");
                                                        },
                                                      ),
                                                      ListTile(
                                                        leading: const Icon(
                                                            Icons.delete),
                                                        title: const Text(
                                                            'Supprimer'),
                                                        onTap: () {
                                                          setState(() {
                                                            widget
                                                                .imageFileList!
                                                                .removeAt(
                                                                    index);
                                                            widget
                                                                .afficheCircles
                                                                .removeAt(
                                                                    index);
                                                            widget.isSelected
                                                                .removeAt(
                                                                    index);
                                                          });
                                                          // Action pour supprimer
                                                          Navigator.pop(
                                                              context);
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
                                                opacity:
                                                    (!widget.afficheCircles[
                                                                index] &&
                                                            afficheCirclesAll)
                                                        ? 0.5
                                                        : 1,
                                                child: Image.file(
                                                  File(widget
                                                      .imageFileList![index]
                                                      .path),
                                                  fit: BoxFit
                                                      .cover, // L'image couvre toute la cellule
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                ),
                                              ),
                                              if (widget.afficheCircles[index])
                                                const CircularProgressIndicator(),
                                              Positioned(
                                                top: 8.0,
                                                right: 8.0,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      widget.isSelected[index] =
                                                          !widget.isSelected[
                                                              index];
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: widget
                                                              .isSelected[index]
                                                          ? Colors.blue
                                                          : Colors.white,
                                                      border: Border.all(
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Icon(
                                                        widget.isSelected[index]
                                                            ? Icons.check
                                                            : Icons
                                                                .radio_button_unchecked,
                                                        color:
                                                            widget.isSelected[
                                                                    index]
                                                                ? Colors.white
                                                                : Colors.blue,
                                                        size: 20.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            )),
                ),
              ],
            ),
          )),
    );
  }
}
