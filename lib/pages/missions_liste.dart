// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:clp_flutter/models/mission.dart';
import 'package:clp_flutter/pages/createMission/departement.dart';
import 'package:clp_flutter/utils/message.dart';
import './mission_page.dart';
import 'package:clp_flutter/services/missions_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../globals.dart' as globals;

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

            // ignore: non_constant_identifier_names
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

            return ListeDesMissionsAAfficher.isEmpty
                ? const CenterMessageWidget(
                    texte:
                        "Aucune remontée d'information\n n'est affectée à cette collecte")
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: ListeDesMissionsAAfficher.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        child: Card(
                          child: Slidable(
                            key: const ValueKey(0),
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    _lancerGoogleMap(missions[index].map);
                                  },
                                  backgroundColor: Color(
                                    globals.getColorMission(
                                        ListeDesMissionsAAfficher[index]
                                            .statut),
                                  ),
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
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          setState(() {
                                            ListeDesMissionsAAfficher[index]
                                                    .moreInfo =
                                                !ListeDesMissionsAAfficher[
                                                        index]
                                                    .moreInfo;
                                          });
                                        },
                                        backgroundColor: Color(
                                          globals.getColorMission(
                                              ListeDesMissionsAAfficher[index]
                                                  .statut),
                                        ),
                                        foregroundColor: Colors.white,
                                        icon: Icons.hdr_plus_sharp,
                                        label: ListeDesMissionsAAfficher[index]
                                                .moreInfo
                                            ? 'Adresse'
                                            : 'Titre',
                                      ),
                                    ],
                                  )
                                : null,
                            child: ListTile(
                              isThreeLine: true,
                              trailing: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: missions[index].typeMission == 'terrain'
                                    ? Image.asset(
                                        'assets/images/terrain.png',
                                        width: 35,
                                        height: 35,
                                      )
                                    : Image.asset(
                                        'assets/images/mairie.png',
                                        width: 35,
                                        height: 35,
                                      ),
                              ),
                              leading: Column(
                                children: [
                                  const Padding(padding: EdgeInsets.all(6)),
                                  ListeDesMissionsAAfficher[index].clp
                                      ? const CircleAvatar(
                                          backgroundColor: Colors.white,
                                          backgroundImage: AssetImage(
                                              'assets/images/veilleco.png'),
                                        )
                                      : const CircleAvatar(
                                          backgroundColor: Colors.white,
                                          backgroundImage: AssetImage(
                                              'assets/images/CLP.png'),
                                        ),
                                ],
                              ),
                              title: Row(children: [
                                Icon(Icons.circle,
                                    color: Color(
                                      globals.getColorMission(
                                          ListeDesMissionsAAfficher[index]
                                              .statut),
                                    )),
                                Text(
                                  '  ${ListeDesMissionsAAfficher[index].typeMission}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ]),
                              subtitle: ListeDesMissionsAAfficher[index]
                                      .moreInfo
                                  ? Text(ListeDesMissionsAAfficher[index].name!)
                                  : Text(
                                      '${ListeDesMissionsAAfficher[index].adresse}\n${ListeDesMissionsAAfficher[index].ville}',
                                      style: const TextStyle(
                                          color: Colors.blueGrey),
                                    ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MissionPage(
                                            collecte: widget.collecte.id,
                                            mission: ListeDesMissionsAAfficher[
                                                index],
                                            defaultIndex: 0)));
                              },
                            ),
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
          centerTitle: true,
          title: Text('Collecte n° : ${widget.collecte.numeroCollecte}'),
        ),
        endDrawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 63, 83, 99),
                ),
                child: Text(
                  'CLP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    _conditionsDesStatuts(),
                    const Divider(
                      height: 40,
                    ),
                    _conditionsDesCommunes(),
                    const Divider(
                      height: 40,
                    ),
                    _typeDeMissions(),
                    const SizedBox(
                      height: 40,
                    )
                  ],
                ),
              )
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
            // Container(
            //   padding: const EdgeInsets.all(20.0),
            //   child: Text('Collecte n° : ${widget.collecte.numeroCollecte}'),
            // ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Liste des missions',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
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
                    height: globals.espacement,
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
          height: globals.espacement,
          child: CheckboxListTile(
            title: const Text('Commune'),
            value: conditionType['mairie'],
            onChanged: (value) {
              setState(() {
                conditionType['mairie'] = value!;
              });
            },
          ),
        ),
        SizedBox(
          height: globals.espacement,
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
          height: globals.espacement,
          child: CheckboxListTile(
            title: const Text('En cours'),
            value: conditionStatut['encours'],
            onChanged: (value) {
              setState(() {
                conditionStatut['encours'] = value!;
              });
            },
          ),
        ),
        SizedBox(
          height: globals.espacement,
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
          height: globals.espacement,
          child: CheckboxListTile(
            title: const Text('Annulée'),
            value: conditionStatut['annule'],
            onChanged: (value) {
              setState(() {
                conditionStatut['annule'] = value!;
              });
            },
          ),
        ),
        SizedBox(
          height: globals.espacement,
          child: CheckboxListTile(
            title: const Text('Refusée'),
            value: conditionStatut['refuse'],
            onChanged: (value) {
              setState(() {
                conditionStatut['refuse'] = value!;
              });
            },
          ),
        ),
        SizedBox(
          height: globals.espacement,
          child: CheckboxListTile(
            title: const Text('Validée'),
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
