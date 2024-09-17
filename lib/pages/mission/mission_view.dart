// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:clp_flutter/models/mission.dart';
import 'package:clp_flutter/pages/mission/ProjetDetails.dart';
import 'package:clp_flutter/pages/mission/view_resume_pdf.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget BlocInfo(String titre, String valeur, int ligne, Color? color) {
    return Container(
      width: ligne == 1
          ? double.infinity
          : MediaQuery.of(context).size.width * 0.45, // Largeur dynamique
      margin: EdgeInsets.symmetric(vertical: 5.0), // Marge verticale
      padding: EdgeInsets.all(10.0), // Padding interne
      decoration: BoxDecoration(
        color: color == null ? Colors.white : color, // Couleur de fond
        borderRadius: BorderRadius.circular(8.0), // Arrondir les coins
      ),
      child: (color == null)
          ? Column(
              children: [
                Text(
                  titre,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black26, // Texte en gris
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  valeur,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black, // Texte en gris
                  ),
                ),
              ],
            )
          : Center(
              child: Text(titre),
            ),
    );
  }

// ignore: non_constant_identifier_names
  Widget Information() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocInfo("Statut", widget.mission.statut, 2, null),
              BlocInfo("Type", widget.mission.typeMission, 2, null),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocInfo("Numéro", widget.mission.id.toString(), 2, null),
              if (widget.mission.passage != null)
                BlocInfo("Date de passage", widget.mission.passage.toString(),
                    2, null),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocInfo("Localisation", widget.mission.id.toString(), 2,
                  Colors.amber),
              if (widget.mission.passage != null)
                BlocInfo("Google Map", widget.mission.passage.toString(), 2,
                    Colors.red.shade400),
            ],
          ),
          BlocInfo("Adresse", widget.mission.adresse, 1, null),
          if (widget.mission.is_projet == 'true')
            ProjetDetails(
                projet: jsonDecode(widget.mission.projet),
                adresse: widget.mission.adresse,
                mission: widget.mission),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Information();
    // return Column(
    //   children: [
    //     SizedBox(
    //       height: 120.0,
    //       child: Center(
    //         child: Text(
    //           globals.getAffichageMission(widget.mission.typeMission),
    //           textAlign: TextAlign.center,
    //           style:
    //               const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    //         ),
    //       ),
    //     ),
    //     StatutImage(statut: widget.mission.statut),
    //     SizedBox(
    //       height: 120.0,
    //       child: Center(
    //         child: Text(
    //           widget.mission.id.toString(),
    //           style:
    //               const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
    //         ),
    //       ),
    //     ),
    //     if (widget.mission.is_projet == 'true')
    //       SizedBox(
    //         height: 60.0,
    //         child: Center(
    //           child: ElevatedButton.icon(
    //             icon: Icon(Icons.info, size: 16),
    //             label: Text('Information sur le projet'),
    //             onPressed: () {
    //               showModalBottomSheet(
    //                 context: context,
    //                 isScrollControlled:
    //                     true, // Permet à la modal de prendre tout l'écran
    //                 builder: (context) {
    //                   return Container(
    //                     height: MediaQuery.of(context).size.height *
    //                         0.9, // 90% de l'écran
    //                     padding: EdgeInsets.all(16.0),
    //                     child: Stack(
    //                       children: [
    //                         Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             SizedBox(
    //                               height: 60.0,
    //                             ),
    //                             Text(
    //                               'Quelques informations sur le projet',
    //                               style: TextStyle(fontSize: 24),
    //                             ),
    //                             SizedBox(height: 20),
    //                             ProjetDetails(
    //                                 projet: jsonDecode(widget.mission.projet),
    //                                 adresse: widget.mission.adresse,
    //                                 mission: widget.mission),
    //                           ],
    //                         ),
    //                         Positioned(
    //                           top: 0,
    //                           right: 0,
    //                           child: IconButton(
    //                             icon: Icon(Icons.close),
    //                             onPressed: () {
    //                               Navigator.pop(context); // Ferme la modal
    //                             },
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   );
    //                 },
    //               );
    //             },
    //             style: ElevatedButton.styleFrom(
    //               foregroundColor: Colors.white,
    //               backgroundColor: Colors.blue,
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(30),
    //               ),
    //               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //             ),
    //           ),
    //         ),
    //       ),
    //     Column(
    //       children: [
    //         const Text('Adresse'),
    //         Center(
    //           child: Text(
    //             widget.mission.adresse,
    //             style: const TextStyle(fontSize: 15.0),
    //           ),
    //         )
    //       ],
    //     ),
    //     const SizedBox(
    //       height: 40,
    //     ),
    //     ElevatedButton.icon(
    //       icon: Icon(Icons.info, size: 16),
    //       label: Text('Voir le résumé du projet'),
    //       onPressed: () {
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => ResumeViewer(mission: widget.mission.id),
    //           ),
    //         );
    //       },
    //     ),
    //     const SizedBox(
    //       height: 40,
    //     ),
    //     widget.mission.passage != null
    //         ? Column(
    //             children: [
    //               Column(
    //                 children: [
    //                   const Text('Date de passage :'),
    //                   Center(
    //                       child: Text(
    //                     widget.mission.passage.toString(),
    //                     style: const TextStyle(fontSize: 30.0),
    //                   )),
    //                 ],
    //               ),
    //               const SizedBox(
    //                 height: 40,
    //               ),
    //             ],
    //           )
    //         : Column(
    //             children: [
    //               widget.mission.statut == 'avalider'
    //                   ? Column(
    //                       children: [
    //                         const Center(
    //                           child: Text(
    //                             'En attente de validation',
    //                             style: TextStyle(
    //                                 backgroundColor: Colors.amber,
    //                                 color: Colors.white,
    //                                 fontWeight: FontWeight.w800,
    //                                 fontSize: 25.0),
    //                           ),
    //                         ),
    //                         Container(
    //                           height: 120,
    //                           alignment: Alignment.center,
    //                           child: ElevatedButton(
    //                             style: const ButtonStyle(
    //                               backgroundColor:
    //                                   WidgetStatePropertyAll(Colors.blueGrey),
    //                             ),
    //                             child: const Text(
    //                                 'Repasser le relevé d\'information \nen statut "en cours"',
    //                                 textAlign: TextAlign.center,
    //                                 style: TextStyle(color: Colors.white)),
    //                             onPressed: () {
    //                               _clotureMission(widget.mission, null);
    //                             },
    //                           ),
    //                         )
    //                       ],
    //                     )
    //                   : Column(
    //                       children: [
    //                         const Text(
    //                             'Entrez la date de passage (obligatoire)'),
    //                         SizedBox(
    //                             height: 80.0,
    //                             child: Padding(
    //                               padding: const EdgeInsets.symmetric(
    //                                   horizontal: 60),
    //                               child: Center(
    //                                 child: SizedBox(
    //                                   width: 100,
    //                                   child: TextField(
    //                                     controller: _dateController,
    //                                     onTap: () {
    //                                       FocusScope.of(context).requestFocus(
    //                                           FocusNode()); // Pour empêcher l'ouverture du clavier

    //                                       _selectDate(context);
    //                                     },
    //                                   ),
    //                                 ),
    //                               ),
    //                             )),
    //                         const SizedBox(
    //                           height: 80.0,
    //                         ),
    //                         SizedBox(
    //                           height: 80.0,
    //                           child: ElevatedButton(
    //                             style: const ButtonStyle(
    //                               backgroundColor:
    //                                   WidgetStatePropertyAll(Colors.blueGrey),
    //                             ),
    //                             child: const Text(
    //                                 "Cloturer le relevé d'information ",
    //                                 style: TextStyle(color: Colors.white)),
    //                             onPressed: () {
    //                               if (_dateController.text.isEmpty) {
    //                                 showDialog(
    //                                     context: context,
    //                                     builder: (BuildContext context) {
    //                                       return AlertDialog(
    //                                         title: const Text(
    //                                             'La date de passage est obligatoire'),
    //                                         actions: [
    //                                           TextButton(
    //                                               onPressed: () {
    //                                                 Navigator.of(context).pop();
    //                                               },
    //                                               child: const Text(
    //                                                   "j'ai compris"))
    //                                         ],
    //                                       );
    //                                     });
    //                               } else {
    //                                 _clotureMission(
    //                                     widget.mission, _dateController.text);
    //                               }
    //                             },
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //             ],
    //           ),
    //   ],
    // );
  }
}
