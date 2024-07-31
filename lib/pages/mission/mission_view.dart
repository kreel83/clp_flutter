// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import '../../globals.dart' as globals;

class StatutImage extends StatelessWidget {
  final String statut;

  const StatutImage({super.key, required this.statut});

  @override
  Widget build(BuildContext context) {
    Icon imagePath;

    switch (statut) {
      case 'encours':
        imagePath = const Icon(
          Icons.directions_walk,
          size: 60,
          color: Colors.blue,
        );
        break;
      case 'avalider':
        imagePath = const Icon(
          Icons.schedule,
          size: 60,
          color: Colors.amber,
        );
        break;
      case 'valide':
        imagePath = const Icon(
          Icons.check,
          color: Colors.green,
          size: 60,
        );
        break;

      default:
        //annulé
        imagePath = const Icon(
          Icons.close,
          color: Colors.red,
          size: 60,
        );
        break;
    }

    return imagePath;
  }
}

class MissionView extends StatefulWidget {
  const MissionView({super.key, this.mission});

  final mission;

  @override
  State<MissionView> createState() => _MissionViewState();
}

class _MissionViewState extends State<MissionView> {
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Future<void> _clotureMission(mission, date) async {
    var headers = {
      'authorization': 'Bearer ${globals.token}',
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    final body = {'mission': mission.id, 'date': date};
    // final body = {'email': 'melodidit@gmail.com', 'password': 'Colibri09'};

    try {
      Response response = await post(
          headers: headers,
          Uri.parse(
              'https://www.la-gazette-eco.fr/api/clp/mission/changeStatutMission'),
          body: jsonEncode(body));
      if (response.statusCode == 200) {
        var json = response.body;
        setState(() {
          widget.mission.statut = json;
        });
      } else {
        // print(mission.id.toString()+" "+_dateController.text);
        // print('NO NO NON ');
      }
    } catch (e) {
      //print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 120.0,
          child: Center(
            child: Text(
              globals.getAffichageMission(widget.mission.typeMission),
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        StatutImage(statut: widget.mission.statut),
        SizedBox(
          height: 120.0,
          child: Center(
            child: Text(
              "Relevé d'informations n° ${widget.mission.id}",
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Column(
          children: [
            const Text('Adresse'),
            Center(
              child: Text(
                widget.mission.adresse,
                style: const TextStyle(fontSize: 15.0),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        widget.mission.passage != null
            ? Column(
                children: [
                  Column(
                    children: [
                      const Text('Date de passage :'),
                      Center(
                          child: Text(
                        widget.mission.passage.toString(),
                        style: const TextStyle(fontSize: 30.0),
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              )
            : Column(
                children: [
                  widget.mission.statut == 'avalider'
                      ? Column(
                          children: [
                            const Center(
                              child: Text(
                                'En attente de validation',
                                style: TextStyle(
                                    backgroundColor: Colors.amber,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 25.0),
                              ),
                            ),
                            Container(
                              height: 120,
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.blueGrey),
                                ),
                                child: const Text(
                                    'Repasser le relevé d\'information \nen statut "en cours"',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  _clotureMission(widget.mission, null);
                                },
                              ),
                            )
                          ],
                        )
                      : Column(
                          children: [
                            const Text(
                                'Entrez la date de passage (obligatoire)'),
                            SizedBox(
                                height: 80.0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 60),
                                  child: Center(
                                    child: SizedBox(
                                      width: 100,
                                      child: TextField(
                                        controller: _dateController,
                                        onTap: () {
                                          FocusScope.of(context).requestFocus(
                                              FocusNode()); // Pour empêcher l'ouverture du clavier

                                          _selectDate(context);
                                        },
                                      ),
                                    ),
                                  ),
                                )),
                            const SizedBox(
                              height: 80.0,
                            ),
                            SizedBox(
                              height: 80.0,
                              child: ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.blueGrey),
                                ),
                                child: const Text(
                                    "Cloturer le relevé d'information ",
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  if (_dateController.text.isEmpty) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'La date de passage est obligatoire'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                      "j'ai compris"))
                                            ],
                                          );
                                        });
                                  } else {
                                    _clotureMission(
                                        widget.mission, _dateController.text);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                ],
              ),
      ],
    );
  }
}
