// ignore_for_file: prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'dart:typed_data';
import 'package:clp_flutter/pages/mission_page.dart';
import 'package:clp_flutter/utils/alert.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage(
      {super.key,
      this.depot,
      required this.collecte,
      required this.mission,
      required this.indexTab});

  final depot;
  final collecte;
  final mission;
  final indexTab;

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  Future<void> deletePhoto(depot) async {
    var headers = {
      'authorization': 'Bearer ${globals.token}',
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    var client = http.Client();
    var uri =
        Uri.parse('https://www.la-gazette-eco.fr/api/clp/mission/deletePhoto');
    var response = await client.post(uri,
        headers: headers,
        body: jsonEncode({
          'id': depot.missionId,
          'folder': depot.rep,
          'type': depot.type,
          'file': depot.documentName
        }));

    if (response.statusCode == 200) {
      Navigator.pop(context, true); // Ferme la boîte de dialogue
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<Uint8List?> getPhoto(depot) async {
    var headers = {
      'authorization': 'Bearer ${globals.token}',
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    var client = http.Client();
    var uri =
        // 'http://mesprojets-laravel.mborgna.vigilience.corp/api/clp/mission/getPhoto');
        Uri.parse('https://www.la-gazette-eco.fr/api/clp/mission/getPhoto');
    var response = await client.post(uri,
        headers: headers,
        body: jsonEncode({
          'name': depot.documentName,
          'type': depot.type,
          'mission': depot.missionId
        }));

    if (response.statusCode == 200) {
      var img = Uri.parse(response.body).data;
      Uint8List? myImage = img?.contentAsBytes();

      return myImage;
    } else {
      throw Exception('Failed to load items');
    }
  }

  @override
  void initState() {
    super.initState();

    // getPhoto(widget.depot);
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Voulez-vous supprimer cette photo ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
            ),
            TextButton(
              child: const Text('Confirmer'),
              onPressed: () async {
                // Mettez ici votre logique pour ce qui doit se passer après la confirmation
                await deletePhoto(widget.depot);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MissionPage(
                          mission: widget.mission,
                          collecte: widget.collecte,
                          defaultIndex: widget.indexTab)),
                );

                Alert.showToast('Document supprimé avec succés');
              },
            ),
          ],
        );
      },
    );
  }

  String convertUrl(collecte, mission, type, document) {
    final url = 'https://www.la-gazette-eco.fr/api/clp/get_photo/' +
        collecte +
        '/' +
        mission +
        '/' +
        type +
        's/' +
        document;
    final data = Uri.encodeFull(url);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.depot.documentName),
          actions: [
            if (widget.depot.deletable)
              IconButton(
                  onPressed: () {
                    _showConfirmationDialog(context);
                  },
                  icon: const Icon(Icons.delete_outline))
          ],
        ),
        // ignore: unnecessary_null_comparison
        body: PhotoView(
          imageProvider: NetworkImage(convertUrl(
                  widget.collecte.toString(),
                  widget.depot.missionId.toString(),
                  widget.depot.type,
                  widget.depot.documentName)
              // '${'http://surveilleco.vigilience.corp/collectes/' + widget.collecte.toString() + '/missions/' + widget.depot.missionId.toString() + '/' + widget.depot.type}s/' + widget.depot.documentName,
              // '${'https://www.la-gazette-eco.fr/api/clp/get_photo/' + widget.collecte.toString() + '/' + widget.depot.missionId.toString() + '/' + widget.depot.type}s/' +
              // widget.depot.documentName,
              ),
        ));
  }
}
