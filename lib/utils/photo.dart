library lge.photos;

import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../globals.dart' as globals;
import 'package:http/http.dart' as http_custom;

Future<bool> sendImageToAPISolo(XFile imageFile, typeDepot, mission) async {
  var uri = Uri.parse(
      'https://www.la-gazette-eco.fr/api/clp/mission/setPicture'); // Replace with your API endpoint

  var request = http_custom.MultipartRequest('POST', uri);

  request.headers['authorization'] = 'Bearer ${globals.token}';
  request.headers['Content-Type'] = 'image/jpeg';
  request.fields['type'] = typeDepot;
  request.fields['mission'] = mission.id.toString();
  var bytes = File(imageFile.path).readAsBytesSync();
  request.fields['image'] = base64Encode(bytes);
  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
      //print('Failed to upload image. Status code: ${response.statusCode}');
    }
  } catch (e) {
    return false;
    //print('Error uploading image: $e');
  }
}

Future<bool> takePicture(mission, collecte, typeMission, context) async {
  final picker = ImagePicker();

  final pickedFile = await picker.pickImage(source: ImageSource.camera);
  XFile image;

  if (pickedFile != null) {
    image = XFile(pickedFile.path);
    var state = await sendImageToAPISolo(image, typeMission, mission);
    return state;
  } else {
    return false;
  }
}
