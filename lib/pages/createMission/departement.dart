// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:clp_flutter/pages/createMission/ville.dart';
import 'package:flutter/material.dart';

class DepartementPage extends StatefulWidget {
  const DepartementPage({super.key, this.collecte});

  final collecte;
  @override
  State<DepartementPage> createState() => _DepartementPageState();
}

class _DepartementPageState extends State<DepartementPage> {
  TextEditingController departmentController = TextEditingController();
  String textValue = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Numéro de département'),
      ),
      body: Center(
        child: Column(children: [
          const SizedBox(
            height: 130,
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Collecte n° : ${widget.collecte.numeroCollecte}',
              style: const TextStyle(fontSize: 30.0),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Département'),
              SizedBox(
                width: 100.0,
                child: Center(
                  child: TextField(
                    controller: departmentController,
                    maxLength: 2,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VillePage(
                              collecte: widget.collecte,
                              dep: departmentController.text)));
                },
                child: const Text('Etape suivante'),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
