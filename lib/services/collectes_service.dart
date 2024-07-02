import 'package:clp_flutter/models/collecte.dart';

import 'dart:convert';
import '../../globals.dart' as globals;
import 'package:http/http.dart' as http;

class CollectesService {
  List<Collecte> parseFiches(String responseBody, String type) {
    final p = jsonDecode(responseBody)[type];
    List<Collecte> collectes = [];
    for (var json in p) {
      var col = Collecte();
      col.id = json['id'];
      col.statut = json['statut'];
      col.status = json['status'];
      col.createdAt = json['created_at'];
      col.numeroCollecte = json['numero_collecte'];
      col.total = json['total'].toString();
      col.missions = json['missions'];
      collectes.add(col);
    }
    return collectes;
  }

  Future getCollectes() async {
    var headers = {
      'authorization': 'Bearer ${globals.token}',
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    var client = http.Client();
    var uri = Uri.parse('https://www.la-gazette-eco.fr/api/clp/collectes');
    var response = await client.post(
      uri,
      headers: headers,
    );

    if (response.statusCode == 200) {
      var json = response.body;
      var ret = [parseFiches(json, 'collectes'), jsonDecode(json)['total']];
      return ret;
    } else {
      throw Exception('Failed to load items');
    }
  }
}
