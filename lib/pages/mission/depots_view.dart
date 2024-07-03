// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:clp_flutter/pages/image_upload.dart';
import 'package:clp_flutter/pages/mission_page.dart';
import 'package:clp_flutter/pages/photo_page.dart';
import 'package:clp_flutter/utils/message.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/depot.dart';
import '../../services/depots_service.dart';
import '../../globals.dart' as globals;
import 'package:http/http.dart' as http_custom;

class DepotsView extends StatefulWidget {
  const DepotsView({super.key, required this.mission, required this.collecte});

  final mission;
  final collecte;

  @override
  State<DepotsView> createState() => _DepotsViewState();
}

class _DepotsViewState extends State<DepotsView> {
  String base64Image = "";
  XFile? _image;
  
  get http => null;

  Future<List<depots>> getDeps(mission) async {
    var missions = await DepotsService().getDepots(mission);
    return missions;
  }

    sendImageToAPISolo(XFile imageFile, typeDepot, mission) async {
    var uri = Uri.parse(
        'https://www.la-gazette-eco.fr/api/clp/mission/setPicture'); // Replace with your API endpoint

  
    var request = http_custom.MultipartRequest('POST', uri);


    request.headers['authorization'] = 'Bearer ${globals.token}';
    request.headers['Content-Type'] = 'image/jpeg';
    request.fields['type'] = typeDepot;
    request.fields['mission'] = mission.id.toString();
    var bytes = File(imageFile.path).readAsBytesSync();
    request.fields['image'] = base64Encode(bytes);
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print(response.statusCode);
        print(request.fields['image']);

      } else {
        //print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      //print('Error uploading image: $e');
    }
  }

    Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = XFile(pickedFile.path);
        sendImageToAPISolo(_image!, 'depots', widget.mission);
        Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MissionPage(
                          mission: widget.mission,
                          collecte: widget.collecte,
                          defaultIndex: 1)),
            );

      } else {
        print('No image selected.');
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Liste des documents'),
          actions: [
            IconButton(
                onPressed: () {
                  
                  _takePicture();
                },
                icon: const Icon(Icons.camera_alt))
          ],
        ),
      floatingActionButton: widget.mission.statut == "encours"
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImageUpload(
                              typeDepot: 'depots',
                              idMission: widget.mission,
                              idCollecte: widget.collecte,
                            ),
                    ),
                );
                // _pickerImageFromGallery();
              },
            )
          : null,
      body: FutureBuilder(
          future: getDeps(widget.mission),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final missions = snapshot.data;
              if (snapshot.data!.isEmpty) {
                return const CenterMessageWidget(
                    texte: 'Aucun document déposé');
              }
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: missions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhotoPage(
                                  collecte: widget.collecte,
                                  depot: missions[index]),
                            ),
                          );
                          setState(() {
                            // print('deleted file');
                          });
                        },
                        leading: const Icon(FontAwesomeIcons.envelope),
                        title: Text(missions[index].documentName),
                      ),
                    );
                  });
            }
          }),
    );
  }
}
