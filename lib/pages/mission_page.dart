import 'dart:convert';

import 'package:clp_flutter/models/depot.dart';
import 'package:clp_flutter/pages/mission/decisions_views.dart';
import 'package:clp_flutter/pages/mission/depots_view.dart';
import 'package:clp_flutter/pages/mission/discussions_view.dart';
import 'package:clp_flutter/pages/mission/mission_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import '../../globals.dart' as globals;

class MissionPage extends StatefulWidget {
  const MissionPage(
      {super.key, this.mission, this.collecte, this.defaultIndex});

  // ignore: prefer_typing_uninitialized_variables
  final defaultIndex;
  // ignore: prefer_typing_uninitialized_variables
  final mission;
  // ignore: prefer_typing_uninitialized_variables
  final collecte;

  @override
  State<MissionPage> createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  late String pdf;
  var isLoaded = false;
  var isLoadedFiche = false;
  int _currentIndex = 0;
  final String titleMisson = "Mission";
  late PageController _pageController;
  List<Depot>? depotsListe;
  final TextEditingController _dateController = TextEditingController();

  final title4 = ['Home', 'Dépots', 'Décisions', 'Discussions'];
  final title3 = ['Home', 'Dépots', 'Discussions'];

  late final List<String> _titles;
  late final List<Center> _pages;

  final pages4 = [
    const Center(child: Text('Home page')),
    const Center(child: Text('Dépots')),
    const Center(child: Text('Décisions')),
    const Center(child: Text('Discussions')),
  ];

  final pages3 = [
    const Center(child: Text('Home page')),
    const Center(child: Text('Dépots')),
    const Center(child: Text('Discussions')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

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

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.defaultIndex;
    _pageController = PageController(initialPage: widget.defaultIndex);
    if (widget.mission.typeMission == "mairie") {
      _titles = title4;
      _pages = pages4;
    } else {
      _titles = title3;
      _pages = pages4;
    }
    get_points_rouges();
  }

  Future<void> _clotureMission(mission, date) async {
    var headers = {
      'authorization': 'Bearer ${globals.token}',
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    final body = {'mission': mission.id, 'date': date};
    // final body = {'email': 'melodidit@gmail.com', 'password': 'Colibri09'};
    print(mission);
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
          widget.mission.passage = date;
        });
      } else {
        // print(mission.id.toString()+" "+_dateController.text);
        // print('NO NO NON ');
      }
    } catch (e) {
      //print(e.toString());
    }
  }

  void get_points_rouges() async {
    var headers = {
      'authorization': 'Bearer ${globals.token}',
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    var client = http.Client();
    var uri = Uri.parse(
        'https://www.la-gazette-eco.fr/api/clp/mission/points_rouges');
    var response = await client.post(uri,
        headers: headers, body: jsonEncode({'mission': widget.mission.id}));

    if (response.statusCode == 200) {
      var json = response.body;
      var result = jsonDecode(json);
      setState(() {
        widget.mission.depots = result['depots'];
        widget.mission.decisions = result['decisions'];
      });

      print(widget.mission.depots);
      print(widget.mission.decisions);
      print(widget.mission.messages);
    } else {
      throw Exception('Failed to load items');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_interpolation_to_compose_strings
        title: Text('N° ${widget.mission.id} à ${widget.mission.commune}'),
        actions: [
          if (widget.mission.statut == 'encours')
            TextButton(
              onPressed: () {
                // Ouvre une modal
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Container(
                        width: 100,
                        height: 200,
                        child: Column(
                          children: [
                            const Text(
                                'Entrez la date de passage (obligatoire)'),
                            SizedBox(
                              height: 80.0,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 60),
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
                              ),
                            ),
                            SizedBox(
                              height: 40.0,
                              child: ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.blueGrey),
                                ),
                                child: const Text("Clôturer",
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
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text(
                'Clôturer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0, // Texte en petit
                ),
              ),
            ),
          if (widget.mission.statut == 'avalider')
            TextButton(
              onPressed: () {
                // Ouvre une modal
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirmation'),
                      content: Text(
                          'Voulez-vous passer cette mission en statut "en cours" ?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Ferme la modal
                          },
                          child: Text('Annuler'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Action de validation
                            _clotureMission(widget.mission, null);
                            Navigator.of(context).pop(); // Ferme la modal
                          },
                          child: Text('Valider'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                'Réactiver',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0, // Texte en petit
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) => {_onItemTapped(index)},
          items: [
            BottomNavigationBarItem(
              label: 'home',
              icon: Stack(children: [
                Icon(Icons.home),
              ]),
            ),
            BottomNavigationBarItem(
              label: 'depots',
              icon: Stack(children: [
                Icon(Icons.list),
                if (widget.mission.depots != null && widget.mission.depots > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                    ),
                  ),
              ]),
            ),
            if (widget.mission.typeMission == "mairie")
              BottomNavigationBarItem(
                label: 'decisions',
                icon: Stack(children: [
                  Icon(Icons.list_alt),
                  if (widget.mission.decisions != null &&
                      widget.mission.decisions > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                      ),
                    ),
                ]),
              ),
            BottomNavigationBarItem(
              label: 'discussions',
              icon: Stack(children: [
                Icon(Icons.comment_rounded),
                if (widget.mission.messages != null &&
                    widget.mission.messages > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                    ),
                  ),
              ]),
            ),
          ]),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          MissionView(mission: widget.mission),
          DepotsView(
              collecte: widget.collecte,
              mission: widget.mission,
              onItemTapped: _onItemTapped),
          if (widget.mission.typeMission == "mairie")
            DecisionsView(
                collecte: widget.collecte,
                mission: widget.mission,
                onItemTapped: _onItemTapped),
          DiscussionsView(collecte: widget.collecte, mission: widget.mission)
        ],
      ),
    );
  }
}
