import 'package:clp_flutter/models/collecte.dart';
import 'package:clp_flutter/models/ville.dart';
import 'package:clp_flutter/pages/missions_liste.dart';
import 'package:clp_flutter/services/collectes_service.dart';
import 'package:clp_flutter/services/mission_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:my_app/services/menu/menuCategorie_liste_service.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:my_app/views/member/fiche.dart';
import 'dart:convert';
import '../../globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';

// import '../../models/fiche.dart';

class VillePage extends StatefulWidget {
  const VillePage({super.key, required this.collecte, required this.dep});

  final dep;
  final collecte;

  @override
  State<VillePage> createState() => _VillePageState();
}

class _VillePageState extends State<VillePage> {
  var isLoadedFiche = false;
  Future<Ville>? villes;
  final TextEditingController _controller = TextEditingController();
  String textValue = "";
  int? total;
  Future<List<Ville>>? filteredCities;

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

  Future<List<Ville>> getVillesfunction(dep) async {
var headers = {
      'authorization': 'Bearer ${globals.token}',
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    var client = http.Client();
    var uri = Uri.parse(
        'http://mesprojets-laravel.mborgna.vigilience.corp/api/clp/getAllCommunes');
    var response = await client.post(uri,
        headers: headers, body: jsonEncode({'dep': dep}));


    if (response.statusCode == 200) {
    Iterable p = json.decode(response.body)['communes'];
    return p.map<Ville>((json) => Ville.fromJson(json)).toList();
      
      
    } else {
      throw Exception('Failed to load items');
    }
  }

  @override
  void initState() {
    super.initState();
    filteredCities = getVillesfunction(widget.dep);
    _controller.addListener(() {
      setState(() {
        
      });
    });
  }

// ignore: non_constant_identifier_names
  Widget BuildListVille(BuildContext context) {
    return FutureBuilder(
      future: filteredCities,
      builder: (context, AsyncSnapshot snapshot) {
        print(snapshot);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur de chargement'),);
        } else {
          List<Ville> filteredCitiesList = snapshot.data.where((Ville city) => 
            city.Vconame!.toLowerCase().contains(_controller.text.toLowerCase())).toList();
          return SlidableAutoCloseBehavior(
            
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(2.0),
              itemCount: filteredCitiesList.length,
              itemBuilder: (BuildContext context, int index) {
                return Slidable(
                  
                  key: const ValueKey(0),
                  startActionPane: ActionPane(
                    extentRatio: 0.8,
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => doNothing(widget.collecte, filteredCitiesList[index].CodeCom, 'terrain'),
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.location_city,
                        label: 'Terrain',
                      ),
                      SlidableAction(
                        onPressed: (context) => doNothing(widget.collecte, filteredCitiesList[index].CodeCom, 'commune'),
                        backgroundColor: Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.museum_outlined,
                        label: "Urbanisme",
                      ),
                    ],
                  ),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.location_city_rounded),
                      title: Text('${filteredCitiesList[index].Vconame}'),
                      onTap: () {},
                    ),
                  ),
                );                               
              }
            ),
          );                        
        }
      }
    );
              
         

  }

  Future<void> doNothing(Collecte collecte, String? commune, String type) async {

    var headers = {
      'authorization': 'Bearer ${globals.token}',
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    var client = http.Client();
    var uri = Uri.parse(
        'http://mesprojets-laravel.mborgna.vigilience.corp/api/clp/mission/setMission');
    var response = await client.post(uri,
        headers: headers, body: jsonEncode({'collecte': collecte.id, 'commune': commune, 'type': type}));

      if (response.statusCode == 200) {
        print('Image successfully uploaded');
      } else {
        print('Handle the error');
      }
    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Missions(
                  collecte: collecte)));
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(8.0),
          child: TextField(
                      controller: _controller,
                      
                      maxLength: 40,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Saisir les premieres lettres d'une ville",
                        border: OutlineInputBorder(),
                      ),
                    ),),
          Expanded(child: BuildListVille(context)),
        ],
      ),
    );
  }
}
