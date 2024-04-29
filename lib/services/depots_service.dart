import 'package:clp_flutter/models/depot.dart';
import 'package:clp_flutter/models/mission.dart';

import '../models/collecte.dart';

import 'dart:convert';
import '../../globals.dart' as globals;
import 'package:http/http.dart' as http;

class DepotsService {
  List<depots> parseDecisions(String responseBody) {
    final p = jsonDecode(responseBody)['decisions'];
    final parsed = p.cast<Map<String, dynamic>>();

    //print(parsed.toString());
    return parsed.map<depots>((json) => depots.fromJson(json)).toList();
  }

  Future<List<depots>> getDecisions(mission) async {
    var headers = {
      'authorization': 'Bearer ' + globals.token,
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    var client = http.Client();
    var uri = Uri.parse(
        'http://mesprojets-laravel.mborgna.vigilience.corp/api/clp/mission');
    var response = await client.post(uri,
        headers: headers, body: jsonEncode({'mission': mission.id}));
    print(mission);

    if (response.statusCode == 200) {
      var json = response.body;
      print(json);
      return parseDecisions(json);
    } else {
      throw Exception('Failed to load items');
    }
  }

  List<depots> parseDepots(String responseBody) {
    final p = jsonDecode(responseBody)['depots'];
    final parsed = p.cast<Map<String, dynamic>>();

    //print(parsed.toString());
    return parsed.map<depots>((json) => depots.fromJson(json)).toList();
  }

  Future<List<depots>> getDepots(mission) async {
 var headers = {
      'authorization': 'Bearer ' + globals.token,
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    var client = http.Client();
    var uri = Uri.parse(
        'http://mesprojets-laravel.mborgna.vigilience.corp/api/clp/mission');
    var response = await client.post(uri,
        headers: headers, body: jsonEncode({'mission': mission.id}));
    print(mission.id);
    print(response.statusCode);

    if (response.statusCode == 200) {
      var json = response.body;
      print(json);
      return parseDepots(json);
    } else {
      throw Exception('Failed to load items');
    }
  }
}
