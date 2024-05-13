import 'dart:convert';
import 'dart:io';

import 'package:clp_flutter/pages/image_upload.dart';
import 'package:clp_flutter/pages/photo_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../globals.dart' as globals;

import '../../models/depot.dart';
import '../../services/depots_service.dart';
import '../mission/pickImage.dart';

class DepotsView extends StatefulWidget {
  DepotsView({super.key, required this.mission, required this.collecte});

  final mission;
  final collecte;

  @override
  State<DepotsView> createState() => _DepotsViewState();
}

class _DepotsViewState extends State<DepotsView> {
  File? _selectedImage;

  String base64Image = "";

  Future<List<depots>> getDeps(mission) async {
    var missions = await DepotsService().getDepots(mission);
    print('test');
    print(missions);
    return missions;
  }

  void _pickerImageFromGallery() async {
    final returnedImage =
        
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage != null) {
      print(returnedImage!.path);
      print(widget.mission);

      final response = await http.post(
        Uri.parse('https://la-gazette-eco.fr/api/clp/mission/setPicture'),
        headers: <String, String>{
          'authorization': 'Bearer ' + globals.token,
          'Content-Type': 'image/jpg;charset=UTF-8',
          'Charset': 'utf-8'
        },
        body: jsonEncode(
            {'image': returnedImage!.path, 'mission': widget.mission}),
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        print('Image successfully uploaded');
      } else {
        print('Handle the error');
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.mission.statut == "encours" ? FloatingActionButton(
        child: const Icon(Icons.add),
        
        onPressed: () {
          print('press');
          print(widget.mission);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    
                    ImageUpload(typeDepot: 'depots', idMission: widget.mission))); 
          // _pickerImageFromGallery();
        },
      ): null,
      body: Column(
        children: [
          FutureBuilder(
              future: getDeps(widget.mission),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  final missions = snapshot.data;
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
                                      builder: (context) =>
                                          PhotoPage(collecte: widget.collecte, depot: missions[index]),
                                          ),
                              );
                              setState(() {
                                print('deleted file');
                              });
                            },
                            leading: const Icon(FontAwesomeIcons.envelope),
                            title: Text(missions[index].documentName),
                          ),
                        );
                      });
                }
              }),
        ],
      ),
    );
  }
}
