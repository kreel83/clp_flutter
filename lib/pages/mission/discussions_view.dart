import 'dart:convert';

import 'package:clp_flutter/models/collecte.dart';
import 'package:clp_flutter/models/discussion.dart';
import 'package:clp_flutter/services/mission_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../globals.dart' as globals;
import 'package:http/http.dart' as http;

import '../../models/depot.dart';
import '../../services/depots_service.dart';

class DiscussionsView extends StatefulWidget {
  DiscussionsView({super.key, required this.mission, required this.collecte});

  final mission;
  final collecte;

  @override
  State<DiscussionsView> createState() => _DiscussionsViewState();
}

class _DiscussionsViewState extends State<DiscussionsView> {
  Future<dynamic>? discussionsListe;
  final TextEditingController _textFieldController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  getDisc(mission) async {
    return await MissionService().getDiscussions(mission);
  }

  @override
  void initState() {
    setState(() {
      discussionsListe = getDisc(widget.mission.id);
    });
    super.initState();
    print('---------');
    print(widget.mission.id);
    print('----------');
  }

  Future<void> _sendDataToApi(int mission, String text) async {
    var headers = {
      'authorization': 'Bearer ' + globals.token,
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    var client = http.Client();
    var uri = Uri.parse(
        'http://mesprojets-laravel.mborgna.vigilience.corp/api/clp/mission/newMessage');
    var response = await client.post(uri,
        headers: headers,
        body: jsonEncode({'mission': mission, 'message': text}));
    print(response.statusCode);

    if (response.statusCode == 200) {
      _textFieldController.clear();
      setState(() {
        discussionsListe = getDisc(mission);
      });
    } else {
      print('Échec de l\'envoi des données. Statut : ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: discussionsListe,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (!snapshot.hasData) {
                    return Container(
                      child: Text('Aucune discussion'),
                    );
                  } else {
                    final discussions = snapshot.data;
                    print(discussions);
                    return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(8.0),
                        itemCount: discussions.length,
                        itemBuilder: (BuildContext context, int index) {
                          print(discussions[index].isSender);

                          return Align(
                            alignment: discussions[index].isSender
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.all(8.0),
                              padding: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: discussions[index].isSender
                                    ? Colors.blue
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                discussions[index].texte,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        });
                  }
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(
                hintText: 'Entrez votre message',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String text = _textFieldController.text;
                    _sendDataToApi(widget.mission.id, text);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
