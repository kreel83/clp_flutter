import 'package:clp_flutter/models/mission.dart';
import 'package:clp_flutter/pages/createMission/departement.dart';
import 'package:clp_flutter/pages/mapsDemo.dart';
import './mission_page.dart';
import 'package:clp_flutter/pages/view_pdf.dart';
import 'package:clp_flutter/services/missions_service.dart';
import 'package:flutter/material.dart';
import '../models/collecte.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:my_app/services/menu/menuCategorie_liste_service.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:my_app/views/member/fiche.dart';
import 'dart:convert';
import '../../globals.dart' as globals;
import 'package:http/http.dart' as http;

// import '../../models/fiche.dart';

class VilleUnique {
  String? nom;
  bool? coche;
}

class Missions extends StatefulWidget {
  const Missions({super.key, this.collecte});

  final collecte;

  @override
  State<Missions> createState() => _MissionsState();
}

class _MissionsState extends State<Missions> {
  var isLoaded = false;
  var isLoadedFiche = false;
  late Future<List<Mission>> missions;
  List<VilleUnique> villesUniquesListe = [];
  bool moreInfo = false;
  Map<String, dynamic> conditionStatut = {
    'encours': true,
    'avalider': true,
    'annule': true,
    'refuse': true,
    'valide': true,
  };

  // Map<String, bool> conditionVille = {};

  Map<String, dynamic> conditionType = {'mairie': true, 'terrain': true};

  Future<void> _lancerGoogleMap(String urlMap) async {
    var url = Uri.parse(urlMap);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "impossible de lancer Google Maps";
    }
  }

  Future<List<Mission>> getMiss(collecte) async {
    var missions = await MissionsService().getCollectes(collecte.id);
    return missions;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      missions = getMiss(widget.collecte);
    });
  }

  bool _checkdisplay(Mission mission) {
    if (conditionStatut[mission.statut] == false) return false;
    if (conditionType[mission.typeMission] == false) return false;

    return true;
  }

// ignore: non_constant_identifier_names
  Widget BuildListMissions(BuildContext context) {
    return FutureBuilder(
        future: missions,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final missions = snapshot.data;

            Map<String?, dynamic> statut = {};
            for (var v in villesUniquesListe) {
              statut[v.nom] = v.coche;
            }

            List<Mission> ListeDesMissionsAAfficher = [];
            for (var m in missions) {
              final test;
              if (villesUniquesListe.isEmpty) {
                test = true;
              } else {
                test = statut[m.ville];
              }
              if (_checkdisplay(m) && test) ListeDesMissionsAAfficher.add(m);
            }

            return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: ListeDesMissionsAAfficher.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Slidable(
                      key: const ValueKey(0),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              _lancerGoogleMap(missions[index].map);
                            },
                            backgroundColor:
                                const Color.fromARGB(255, 116, 60, 60),
                            foregroundColor: Colors.white,
                            icon: Icons.map,
                            label: 'google map',
                          ),
                        ],
                      ),
                      endActionPane: ListeDesMissionsAAfficher[index]
                                  .typeMission ==
                              "terrain"
                          ? ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    setState(() {
                                      ListeDesMissionsAAfficher[index]
                                              .moreInfo =
                                          !ListeDesMissionsAAfficher[index]
                                              .moreInfo;
                                    });
                                  },
                                  backgroundColor:
                                      const Color.fromARGB(255, 116, 60, 60),
                                  foregroundColor: Colors.white,
                                  icon: Icons.hdr_plus_sharp,
                                  label: 'Titre',
                                ),
                              ],
                            )
                          : null,
                      child: ListTile(
                        isThreeLine: true,
                        trailing: Icon(
                          globals.getIconeMission(
                              ListeDesMissionsAAfficher[index].statut),
                          size: 20,
                          color: Color(
                            globals.getColorMission(
                                ListeDesMissionsAAfficher[index].statut),
                          ),
                        ),
                        leading: missions[index].typeMission == 'terrain'
                            ? Icon(
                                Icons.house_sharp,
                                size: 40.0,
                                color: Color(globals
                                    .getMissionAttribute(
                                        ListeDesMissionsAAfficher[index]
                                            .typeMission)!
                                    .color),
                              )
                            : Icon(Icons.location_city_sharp,
                                size: 40.0,
                                color: Color(globals
                                    .getMissionAttribute(
                                        ListeDesMissionsAAfficher[index]
                                            .typeMission)!
                                    .color)),
                        title: Text(
                          '${ListeDesMissionsAAfficher[index].typeMission} - ${ListeDesMissionsAAfficher[index].statut}',
                          style: TextStyle(color: Colors.grey),
                        ),
                        subtitle: ListeDesMissionsAAfficher[index].moreInfo
                            ? Text(ListeDesMissionsAAfficher[index].name!)
                            : Text(
                                '${ListeDesMissionsAAfficher[index].adresse}\n${ListeDesMissionsAAfficher[index].ville}',
                                style: TextStyle(color: Colors.blueGrey),
                              ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MissionPage(
                                      collecte: widget.collecte.id,
                                      mission:
                                          ListeDesMissionsAAfficher[index])));
                        },
                      ),
                    ),
                  );
                });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Collecte n° : ${widget.collecte.numeroCollecte}'),
        ),
        endDrawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'CLP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              _conditionsDesStatuts(),
              const Divider(
                height: 40,
              ),
              _conditionsDesCommunes(),
              const Divider(
                height: 40,
              ),
              _typeDeMissions(),
              const Divider(
                height: 40,
              ),
            ],
          ),
        ),
        floatingActionButton: widget.collecte.statut == 1
            ? FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DepartementPage(collecte: widget.collecte)));
                },
              )
            : null,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text('Collecte n° : ${widget.collecte.numeroCollecte}'),
            ),
            Container(
              child: widget.collecte.statut == 5
                  ? TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xffF18265),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PDFViewer(collecte: widget.collecte.id),
                          ),
                        );
                      },
                      child: const Text(
                        "Facture",
                        style: TextStyle(
                          color: Color(0xffffffff),
                        ),
                      ),
                    )
                  : null,
            ),
            Expanded(child: BuildListMissions(context))
          ],
        ));
  }

  Widget _conditionsDesCommunes() {
    return FutureBuilder(
        future: missions,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final missions = snapshot.data;

            if (villesUniquesListe.isEmpty) {
              List<dynamic> villes =
                  missions.map((mission) => mission.ville).toList();

              Set<dynamic> villesUniques = villes.toSet();

              for (var ville in villesUniques) {
                var v = VilleUnique();
                v.nom = ville;
                v.coche = true;
                villesUniquesListe.add(v);
                // conditionVille[ville] = true;
              }
            }

            // List<dynamic> villesUniquesListe = villesUniques.toList();
            // villesUniques.map((e) => conditionCommunes.add(false));
            return ListView.builder(
                padding: const EdgeInsets.all(0.0),
                itemCount: villesUniquesListe.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 30.0,
                    child: CheckboxListTile(
                      title: Text(villesUniquesListe[index].nom!.substring(6)),
                      value: villesUniquesListe[index].coche!,
                      onChanged: (value) {
                        setState(() {
                          villesUniquesListe[index].coche =
                              !villesUniquesListe[index].coche!;
                        });
                      },
                    ),
                  );
                });
          }
        });
  }

  Widget _typeDeMissions() {
    return Column(
      children: [
        SizedBox(
          height: 30,
          child: CheckboxListTile(
            title: Text('Commune'),
            value: conditionType['mairie'],
            onChanged: (value) {
              setState(() {
                conditionType['mairie'] = value!;
              });
            },
          ),
        ),
        SizedBox(
          height: 30,
          child: CheckboxListTile(
            title: const Text('Terrain'),
            value: conditionType['terrain'],
            onChanged: (value) {
              setState(() {
                conditionType['terrain'] = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _conditionsDesStatuts() {
    return Column(
      children: [
        SizedBox(
          height: 30,
          child: CheckboxListTile(
            title: Text('En cours'),
            value: conditionStatut['encours'],
            onChanged: (value) {
              setState(() {
                conditionStatut['encours'] = value!;
              });
            },
          ),
        ),
        SizedBox(
          height: 30,
          child: CheckboxListTile(
            title: const Text('A valider'),
            value: conditionStatut['avalider'],
            onChanged: (value) {
              setState(() {
                conditionStatut['avalider'] = value!;
              });
            },
          ),
        ),
        SizedBox(
          height: 30,
          child: CheckboxListTile(
            title: Text('Annulée'),
            value: conditionStatut['annule'],
            onChanged: (value) {
              setState(() {
                conditionStatut['annule'] = value!;
              });
            },
          ),
        ),
        SizedBox(
          height: 30,
          child: CheckboxListTile(
            title: Text('Refusée'),
            value: conditionStatut['refuse'],
            onChanged: (value) {
              setState(() {
                conditionStatut['refuse'] = value!;
              });
            },
          ),
        ),
        SizedBox(
          height: 30,
          child: CheckboxListTile(
            title: Text('Validée'),
            value: conditionStatut['valide'],
            onChanged: (value) {
              setState(() {
                conditionStatut['valide'] = value!;
              });
            },
          ),
        )
      ],
    );
  }
}


//,BuildListMissions(context)



