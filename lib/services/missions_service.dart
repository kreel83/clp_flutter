import 'package:clp_flutter/models/mission.dart';
import 'dart:convert';
import '../../globals.dart' as globals;
import 'package:http/http.dart' as http;

class MissionsService {
  List<Mission> parseMissions(String responseBody) {
    final p = jsonDecode(responseBody)['missions'];
    final parsed = p.cast<Map<String, dynamic>>();

    print(parsed.toString());
    return parsed.map<Mission>((json) => Mission.fromJson(json)).toList();
  }

  Future<List<Mission>> getCollectes(collecte) async {
    var headers = {
      'authorization': 'Bearer ${globals.token}',
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    var client = http.Client();
    var uri = Uri.parse('https://www.la-gazette-eco.fr/api/clp/missions');
    var response = await client.post(uri,
        headers: headers, body: jsonEncode({'collecte': collecte}));

    if (response.statusCode == 200) {
      var json = response.body;
      return parseMissions(json);
    } else {
      throw Exception('Failed to load items');
    }
  }
}
