// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:clp_flutter/services/mission_service.dart';
import 'package:clp_flutter/utils/message.dart';
import 'package:flutter/material.dart';
import '../../globals.dart' as globals;
import 'package:http/http.dart' as http;

class DiscussionsView extends StatefulWidget {
  const DiscussionsView(
      {super.key, required this.mission, required this.collecte});

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
  }

  Future<void> _sendDataToApi(int mission, String text) async {
    var headers = {
      'authorization': 'Bearer ${globals.token}',
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    var client = http.Client();
    var uri =
        Uri.parse('https://www.la-gazette-eco.fr/api/clp/mission/newMessage');
    var response = await client.post(uri,
        headers: headers,
        body: jsonEncode({'mission': mission, 'message': text}));

    if (response.statusCode == 200) {
      _textFieldController.clear();
      setState(() {
        discussionsListe = getDisc(mission);
      });
    } else {
      //print('Échec de l\'envoi des données. Statut : ${response.statusCode}');
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
                    return const CenterMessageWidget(
                        texte: 'Commencez votre discussion !');
                  } else {
                    final discussions = snapshot.data;
                    return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(8.0),
                        itemCount: discussions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Align(
                            alignment: discussions[index].isSender
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: discussions[index].isSender
                                    ? Colors.blue
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                discussions[index].texte,
                                style: const TextStyle(color: Colors.white),
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
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(
                hintText: 'Entrez votre message',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
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
