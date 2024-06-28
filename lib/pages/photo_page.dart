// ignore_for_file: prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings

import 'dart:typed_data';
import 'package:clp_flutter/utils/alert.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key, this.depot, required this.collecte});

  final depot;
  final collecte;

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
    var uri = Uri.parse(
        'http://mesprojets-laravel.mborgna.vigilience.corp/api/clp/mission/deletePhoto');
    var response = await client.post(uri,
        headers: headers,
        body: jsonEncode({
          'id': depot.missionId,
          'folder': depot.rep,
          'type': depot.type,
          'file': depot.documentName
        }));

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
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
              onPressed: () {
                // Mettez ici votre logique pour ce qui doit se passer après la confirmation
                deletePhoto(widget.depot);
                Navigator.pop(context, true);
                Alert.showToast('Document supprimé avec succés');
              },
            ),
          ],
        );
      },
    );
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
          imageProvider: NetworkImage(
            '${'http://surveilleco.vigilience.corp/collectes/' + widget.collecte.toString() + '/missions/' + widget.depot.missionId.toString() + '/' + widget.depot.type}s/' +
                widget.depot.documentName,
          ),
        ));
  }
}
