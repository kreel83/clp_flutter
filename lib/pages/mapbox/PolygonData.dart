import 'dart:convert';

import 'package:mapbox_gl/mapbox_gl.dart';

class PolygonData {
  List<List<dynamic>> coordinates;

  PolygonData({required this.coordinates});

  // Méthode pour convertir en liste de LatLng
  List<LatLng> toLatLngList() {
    return coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
  }
}

// Fonction pour parser le JSON reçu de l'API
List<PolygonData> parsePolygonData(List<dynamic> jsonData) {
  return jsonData.map((item) {
    item = jsonDecode(item);
    List<List<double>> coords = (item as List<dynamic>).map((coord) {
      // Ici on convertit les coordonnées de String à double
      return [
        double.parse(coord[0]), // Longitude
        double.parse(coord[1]) // Latitude
      ];
    }).toList();

    return PolygonData(coordinates: coords);
  }).toList();
}
