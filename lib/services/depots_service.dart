import 'package:clp_flutter/models/depot.dart';
import 'dart:convert';
import '../../globals.dart' as globals;
import 'package:http/http.dart' as http;

class DepotsService {
  List<Depot> parseDecisions(String responseBody) {
    final p = jsonDecode(responseBody)['decisions'];
    final parsed = p.cast<Map<String, dynamic>>();

    //print(parsed.toString());
    return parsed.map<Depot>((json) => Depot.fromJson(json)).toList();
  }

  Future<List<Depot>> getDecisions(mission) async {
    var headers = {
      'authorization': 'Bearer ${globals.token}',
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    var client = http.Client();
    var uri = Uri.parse('https://www.la-gazette-eco.fr/api/clp/mission');
    var response = await client.post(uri,
        headers: headers, body: jsonEncode({'mission': mission.id}));

    if (response.statusCode == 200) {
      var json = response.body;
      return parseDecisions(json);
    } else {
      throw Exception('Failed to load items');
    }
  }

  List<Depot> parseDepots(String responseBody) {
    final p = jsonDecode(responseBody)['depots'];
    final parsed = p.cast<Map<String, dynamic>>();

    //print(parsed.toString());
    return parsed.map<Depot>((json) => Depot.fromJson(json)).toList();
  }

  Future<List<Depot>> getDepots(mission) async {
    var headers = {
      'authorization': 'Bearer ${globals.token}',
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    var client = http.Client();
    var uri = Uri.parse('https://www.la-gazette-eco.fr/api/clp/mission');
    var response = await client.post(uri,
        headers: headers, body: jsonEncode({'mission': mission.id}));

    if (response.statusCode == 200) {
      var json = response.body;
      return parseDepots(json);
    } else {
      throw Exception('Failed to load items');
    }
  }
}
