import 'package:clp_flutter/pages/missions_liste.dart';
import 'package:clp_flutter/services/collectes_service.dart';
import 'package:flutter/material.dart';
import '../models/collecte.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:my_app/services/menu/menuCategorie_liste_service.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:my_app/views/member/fiche.dart';
import 'dart:convert';
import '../../globals.dart' as globals;
import 'package:http/http.dart' as http;

// import '../../models/fiche.dart';

class Collectes extends StatefulWidget {
  const Collectes({super.key});

  @override
  State<Collectes> createState() => _CollectesState();
}

class _CollectesState extends State<Collectes> {
  var isLoadedFiche = false;
  Future<dynamic>? collectesListe;
  int? total;

  Map<String, dynamic> condition = {
    '1': true,
    '2': true,
    '3': true,
    '4': true,
    '5': true,
  };

  bool isMenuOpen = false;
  bool isLoadedCollectes = false;

  void openMenu() {
    setState(() {
      isMenuOpen = true;
    });
  }

  void closeMenu() {
    setState(() {
      isMenuOpen = false;
    });
  }

  getColls() async {
    var c = await CollectesService().getCollectes();
    return c;
  }

  @override
  void initState() {
    collectesListe = getColls();
    super.initState();
  }

// ignore: non_constant_identifier_names
  Widget BuildListCollecte(BuildContext context) {
    return FutureBuilder(
        future: collectesListe,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final collectes = snapshot.data[0];
            return Column(
              children: [
                SizedBox(
                  height: 70,
                  child: Center(
                    child: Text('Rémunération depuis le début de l\'année  : ' +
                        snapshot.data[1].toString() +
                        ' €'),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(2.0),
                      itemCount: collectes.length,
                      itemBuilder: (BuildContext context, int index) {
                        return condition[collectes[index].statut.toString()]
                            ? Card(
                                child: ListTile(
                                  tileColor: Color(globals.getColorCollecte(collectes[index].statut)),
                                  isThreeLine: true,
                                  leading: const FlutterLogo(size: 72.0),
                                  title: Text(
                                      'Collecte N° ${collectes[index].numeroCollecte} - ${collectes[index].total.toString()}€',
                                      style: TextStyle(color: Colors.white),),
                                  subtitle: Text(
                                      '${collectes[index].status}\ncréée le ${collectes[index].createdAt}', style: TextStyle(color: Colors.white)),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Missions(
                                                collecte: collectes[index])));
                                  },
                                ),
                              )
                            : null;
                      }),
                ),
              ],
            );
          }
        });
  }

  Future<void> _addCollecte() async {
    var uri = Uri.parse(
        'http://mesprojets-laravel.mborgna.vigilience.corp/api/clp/addCollecte'); // Replace with your API endpoint

    var headers = {
      'authorization': 'Bearer ${globals.token}',
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    var client = http.Client();

    var response = await client.post(
      uri,
      headers: headers,
    );

    if (response.statusCode == 200) {
          Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Collectes()));
    } else {
      throw Exception('Failed to load items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Liste des collections'),
      ),
      body: BuildListCollecte(context),
      floatingActionButton: FloatingActionButton(
        // child: const Icon(Icons.add),
        child: const Icon(Icons.add),
        
        
        
        onPressed: () {

          _addCollecte();
          // _pickImage();
        },
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: globals.mainColor,
              ),
              child: Text(
                'CLP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: globals.espacement,
                  child: CheckboxListTile(
                    title: Text('En cours'),
                    value: condition['1'],
                    onChanged: (value) {
                      setState(() {
                        condition['1'] = value!;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: globals.espacement,
                  child: CheckboxListTile(
                    title: Text('Annulée'),
                    value: condition['2'],
                    onChanged: (value) {
                      setState(() {
                        condition['2'] = value!;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: globals.espacement,
                  child: CheckboxListTile(
                    title: Text('Refusée'),
                    value: condition['3'],
                    onChanged: (value) {
                      setState(() {
                        condition['3'] = value!;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: globals.espacement,
                  child: CheckboxListTile(
                    title: Text('Validée'),
                    value: condition['4'],
                    onChanged: (value) {
                      setState(() {
                        condition['4'] = value!;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: globals.espacement,
                  child: CheckboxListTile(
                    title: Text('Payée'),
                    value: condition['5'],
                    onChanged: (value) {
                      setState(() {
                        condition['5'] = value!;
                      });
                    },
                  ),
                )
              ],
            )

            // Ajoute d'autres options du menu selon tes besoins
          ],
        ),
      ),
    );
  }
}
