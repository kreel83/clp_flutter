import 'package:clp_flutter/models/collecte.dart';
import 'package:clp_flutter/pages/login.dart';
import 'package:clp_flutter/pages/missions_liste.dart';
import 'package:clp_flutter/pages/view_pdf.dart';
import 'package:clp_flutter/services/collectes_service.dart';
import 'package:clp_flutter/utils/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

  bool hasNonOneStatus(List<Collecte> collectionFuture) {
    return collectionFuture.any((collecte) => collecte.statut == 1);
  }

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

  Future<void> _refresh() async {
    collectesListe = getColls();
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
                    child: Text(
                        'Rémunération depuis le début de l\'année  : ${snapshot.data[1]} €'),
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
                            ? Slidable(
                                key: const ValueKey(0),
                                startActionPane: collectes[index].statut == 5
                                    ? ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PDFViewer(
                                                          collecte:
                                                              collectes[index]
                                                                  .id),
                                                ),
                                              );
                                            },
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 245, 72, 72),
                                            foregroundColor: Colors.white,
                                            icon: Icons.file_download,
                                            label: 'Afficher la facture',
                                          ),
                                        ],
                                      )
                                    : null,
                                child: Card(
                                  child: ListTile(
                                    tileColor: Color(globals.getColorCollecte(
                                        collectes[index].statut)),
                                    isThreeLine: true,
                                    leading: Column(
                                      children: [
                                        const Padding(
                                            padding: EdgeInsets.all(6)),
                                        CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Center(
                                            child: Text(
                                              collectes[index]
                                                  .missions
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color(
                                                      globals.getColorCollecte(
                                                          collectes[index]
                                                              .statut)),
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    title: Text(
                                      'Collecte N° ${collectes[index].numeroCollecte} - ${collectes[index].total.toString()}€',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                        '${collectes[index].status}\ncréée le ${collectes[index].createdAt}',
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Missions(
                                                  collecte: collectes[index])));
                                    },
                                  ),
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

  void _confirmationNewCollecte(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirmation',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.amber),
          ),
          content: const Text(
            'Voulez-vous créer\n un nouvelle collecte ?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Non',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
            ),
            TextButton(
              child: const Text('Oui'),
              onPressed: () {
                // Mettez ici votre logique pour ce qui doit se passer après la confirmation
                _addCollecte();
                Navigator.pop(context, true);
                Alert.showToast('Nouvelle collecte créée');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addCollecte() async {
    var uri = Uri.parse(
        'https://www.la-gazette-eco.fr/api/clp/addCollecte'); // Replace with your API endpoint

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
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const Collectes()));
    } else {
      throw Exception('Failed to load items');
    }
  }

  void _logout(BuildContext context) {
    // Logique de déconnexion ici
    // Vous pouvez rediriger l'utilisateur vers l'écran de connexion
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LogInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Liste des collectes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: PopScope(
        canPop: false,
        child: RefreshIndicator(
            onRefresh: _refresh, child: BuildListCollecte(context)),
      ),
      floatingActionButton: FutureBuilder<dynamic>(
        future: collectesListe,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final showFloatingActionButton = hasNonOneStatus(snapshot.data[0]);
            if (!showFloatingActionButton) {
              return FloatingActionButton(
                onPressed: () {
                  _confirmationNewCollecte(context);
                },
                child: const Icon(Icons.add),
              );
            } else {
              return const SizedBox
                  .shrink(); // Hide the button if there's an element with status 1
            }
          } else if (snapshot.hasError) {
            return const SizedBox.shrink(); // Or you can show an error widget
          }

          // Show a progress indicator while waiting for the future
          return const SizedBox.shrink();
        },
      ),
      // floatingActionButton: _isCollecteOpen
      //     ? FloatingActionButton(
      //         // child: const Icon(Icons.add),
      //         child: const Icon(Icons.add),

      //         onPressed: () {
      //           _confirmationNewCollecte(context);
      //         },
      //       )
      //     : null,
      // endDrawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       DrawerHeader(
      //         decoration: BoxDecoration(
      //           color: globals.mainColor,
      //         ),
      //         child: const Text(
      //           'CLP',
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontSize: 24,
      //           ),
      //         ),
      //       ),
      //       Column(
      //         children: [
      //           SizedBox(
      //             height: globals.espacement,
      //             child: CheckboxListTile(
      //               title: const Text('En cours'),
      //               value: condition['1'],
      //               onChanged: (value) {
      //                 setState(() {
      //                   condition['1'] = value!;
      //                 });
      //               },
      //             ),
      //           ),
      //           SizedBox(
      //             height: globals.espacement,
      //             child: CheckboxListTile(
      //               title: const Text('Annulée'),
      //               value: condition['2'],
      //               onChanged: (value) {
      //                 setState(() {
      //                   condition['2'] = value!;
      //                 });
      //               },
      //             ),
      //           ),
      //           SizedBox(
      //             height: globals.espacement,
      //             child: CheckboxListTile(
      //               title: const Text('Refusée'),
      //               value: condition['3'],
      //               onChanged: (value) {
      //                 setState(() {
      //                   condition['3'] = value!;
      //                 });
      //               },
      //             ),
      //           ),
      //           SizedBox(
      //             height: globals.espacement,
      //             child: CheckboxListTile(
      //               title: const Text('Validée'),
      //               value: condition['4'],
      //               onChanged: (value) {
      //                 setState(() {
      //                   condition['4'] = value!;
      //                 });
      //               },
      //             ),
      //           ),
      //           SizedBox(
      //             height: globals.espacement,
      //             child: CheckboxListTile(
      //               title: const Text('Payée'),
      //               value: condition['5'],
      //               onChanged: (value) {
      //                 setState(() {
      //                   condition['5'] = value!;
      //                 });
      //               },
      //             ),
      //           )
      //         ],
      //       )

      //       // Ajoute d'autres options du menu selon tes besoins
      //     ],
      //   ),
      // ),
    );
  }
}
