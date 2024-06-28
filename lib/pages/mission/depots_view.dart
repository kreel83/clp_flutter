// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:clp_flutter/pages/image_upload.dart';
import 'package:clp_flutter/pages/photo_page.dart';
import 'package:clp_flutter/utils/message.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/depot.dart';
import '../../services/depots_service.dart';

class DepotsView extends StatefulWidget {
  const DepotsView({super.key, required this.mission, required this.collecte});

  final mission;
  final collecte;

  @override
  State<DepotsView> createState() => _DepotsViewState();
}

class _DepotsViewState extends State<DepotsView> {
  String base64Image = "";

  Future<List<depots>> getDeps(mission) async {
    var missions = await DepotsService().getDepots(mission);
    return missions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            )));
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
