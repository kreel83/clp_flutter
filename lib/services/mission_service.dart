import 'package:clp_flutter/models/discussion.dart';
import 'package:clp_flutter/models/ville.dart';
import 'dart:convert';
import '../../globals.dart' as globals;
import 'package:http/http.dart' as http;

class MissionService {
  List<Discussion> parseDiscussions(String responseBody) {
    Iterable p = json.decode(responseBody)['discussions'];
    return p.map<Discussion>((json) => Discussion.fromJson(json)).toList();
  }

  List<Ville> parseVilles(String responseBody) {
    Iterable p = json.decode(responseBody)['communes'];
    return p.map<Ville>((json) => Ville.fromJson(json)).toList();
  }

  Future getDiscussions(mission) async {
    var headers = {
      'authorization': 'Bearer ${globals.token}',
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    var client = http.Client();
    var uri = Uri.parse(
        'http://mesprojets-laravel.mborgna.vigilience.corp/api/clp/mission');
    var response = await client.post(uri,
        headers: headers, body: jsonEncode({'mission': mission}));

    if (response.statusCode == 200) {
      var json = response.body;

      var ret = parseDiscussions(json);
      return ret;
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<List<Ville>> getVilles(departement) async {
    var headers = {
      'authorization': 'Bearer ${globals.token}',
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    var client = http.Client();
    var uri = Uri.parse(
        'http://mesprojets-laravel.mborgna.vigilience.corp/api/clp/getAllCommunes');
    var response = await client.post(uri,
        headers: headers, body: jsonEncode({'dep': departement}));

    if (response.statusCode == 200) {
      var json = response.body;
      var ret = parseVilles(json);

      return ret;
    } else {
      throw Exception('Failed to load items');
    }
  }
}
