
import 'dart:convert';
import '../../models/mission.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import '../../globals.dart' as globals;

class MissionView extends StatefulWidget {
  const MissionView({super.key, this.mission});

  final mission;

  @override
  State<MissionView> createState() => _MissionViewState();
}

class _MissionViewState extends State<MissionView> {

   TextEditingController _dateController = TextEditingController();
   

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != DateTime.now())
      setState(() {
        _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
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
          Uri.parse('http://mesprojets-laravel.mborgna.vigilience.corp/api/clp/mission/changeStatutMission'),
          body: jsonEncode(body));
      print(response.statusCode);    
      if (response.statusCode == 200) {
        var json = response.body;
        print(json);    
        setState(() {
          widget.mission.statut = json;
        });
        print(json);
      } else {
        print(mission.id.toString()+" "+_dateController.text);
        print('NO NO NON ');
      }
    } catch (e) {
      print(e.toString());
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
     
        child: Column(
          children: [
            SizedBox(
              height: 120.0,
              child: Center(

                child: Text(globals.getAffichageMission(widget.mission.typeMission),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold
                      ),
                ),
                ),
              ),
            SizedBox(
              height: 120.0,
              child: Center(child: Text("Relevé d'informations n° ${widget.mission.id}",
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ),

            Column(
              children: [
                widget.mission.statut == 'avalider' ?
                
                Column(
                  children: [
                    const Center(child: Text('En attente de validation',
                      style: TextStyle(
                          backgroundColor: Colors.blueAccent,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 25.0
                        
                        ),
                      ),
                    ),
                    Container(
                      height: 120,
                      alignment: Alignment.center,
                      child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blueGrey),
                    
                  ),
                  child: const Text('Repasser le relevé d\'information \nen statut "en cours"',
                  textAlign: TextAlign.center, 
                        style: TextStyle(color: Colors.white)),
                onPressed: () {
                    _clotureMission(widget.mission, null);
                },
                ),
                    )
                  ],
                ) 
                :
                Container(

                  child: Column(
                    children: [
                      SizedBox(
                        height: 80.0,
                        
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: TextField(
                          controller: _dateController,
                          decoration: const InputDecoration(
                            hintText: 'Entrez la date de passage (obligatoire)',
                          ),
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode()); // Pour empêcher l'ouverture du clavier
                            _selectDate(context);
                          },
                        ),
                      )
                                      ,
                    )
                  ),
              const SizedBox(
                height: 80.0,
              ),
              SizedBox(
                height: 80.0,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blueGrey),
                    
                  ),
                  child: const Text("Cloturer le relevé d'information ", style: TextStyle(color: Colors.white)),
                onPressed: () {
                    if (_dateController.text.isEmpty) {
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('La date de passage est obligatoire'),
                            actions: [
                              TextButton(onPressed: () {
                                Navigator.of(context).pop();
                              }, 
                              child: Text("j'ai compris"))
                            ],
                          );
                        });
                    } else {

                    _clotureMission(widget.mission, _dateController.text);
                    }
                },
                ),
                ),
                    ],
                  ),
                ),

              ],
              ),

            
          ],
        )
     
    );
  }
}
