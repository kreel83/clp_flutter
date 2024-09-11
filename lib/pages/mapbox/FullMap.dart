import 'dart:convert';

import 'package:clp_flutter/models/mission.dart';
import 'package:clp_flutter/pages/mapbox/PolygonData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../../globals.dart' as globals;

class CarteMapboxPage extends StatefulWidget {
  final Mission mission;
  CarteMapboxPage({required this.mission});

  @override
  _CarteMapboxPageState createState() => _CarteMapboxPageState();
}

class _CarteMapboxPageState extends State<CarteMapboxPage> {
  late LatLng _centreCarte; // Coordonnées de la Tour Eiffel
  MapboxMapController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<String> parties = widget.mission.coords!.split(',');

    // Convertir les parties en double pour obtenir les coordonnées
    double latitude = double.parse(parties[0]);
    double longitude = double.parse(parties[1]);
    _centreCarte = LatLng(latitude, longitude);
  }

  // Fonction pour ajouter un marqueur sur la carte
  void _ajouterMarqueur(LatLng position) {
    _controller?.addSymbol(
      SymbolOptions(
        geometry: position,
        iconSize: 2.0,
        iconImage:
            "assets/icon.png", // Remplacez par votre propre icône si nécessaire
        iconAnchor: "bottom",
      ),
    );
  }

  // Fonction pour initialiser la carte et ajouter les layers
  void _onMapCreated(MapboxMapController controller) {
    _controller = controller;

    // Ajout des cercles dans les différents layers avec un délai pour chaque groupe
    Future.delayed(Duration(seconds: 1), () => _addPolygon(controller));
    Future.delayed(Duration(seconds: 2), () => _ajouterMarqueur(_centreCarte));
  }

  LatLngBounds calculateBounds(List<LatLng> polygonCoords) {
    double? minLat, maxLat, minLng, maxLng;

    for (var coord in polygonCoords) {
      if (minLat == null || coord.latitude < minLat) {
        minLat = coord.latitude;
      }
      if (maxLat == null || coord.latitude > maxLat) {
        maxLat = coord.latitude;
      }
      if (minLng == null || coord.longitude < minLng) {
        minLng = coord.longitude;
      }
      if (maxLng == null || coord.longitude > maxLng) {
        maxLng = coord.longitude;
      }
    }

    return LatLngBounds(
      southwest: LatLng(minLat!, minLng!), // coin inférieur gauche
      northeast: LatLng(maxLat!, maxLng!), // coin supérieur droit
    );
  }

  void centerMapOnPolygon(
      MapboxMapController controller, List<LatLng> polygonCoords) {
    LatLngBounds bounds = calculateBounds(polygonCoords);

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        bounds, left: 150.0, // Padding à gauche
        top: 150.0, // Padding en haut
        right: 150.0, // Padding à droite
        bottom: 150.0,
      ), // Zoom sur les limites du polygone avec un padding de 50
    );
  }

  void addPolygonsToMap(
      List<PolygonData> polygonsData, MapboxMapController controller) {
    polygonsData.forEach((polygon) {
      List<LatLng> polygonCoords = polygon.toLatLngList();
      controller.addFill(
        FillOptions(
          geometry: [polygon.toLatLngList()], // Liste des coordonnées LatLng
          fillColor: '#FF0000', // Couleur du polygone
          fillOpacity: 0.5, // Opacité du polygone
        ),
      );
      centerMapOnPolygon(controller, polygonCoords);
    });
  }

  void _addPolygon(controller) async {
    var headers = {
      'authorization': 'Bearer ${globals.token}',
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    Response response = await post(
      headers: headers,
      body: jsonEncode({'mission': widget.mission.id}),
      Uri.parse('https://www.la-gazette-eco.fr/api/clp/parcelles'),
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = await jsonDecode(response.body);
      List<PolygonData> polygonsData = parsePolygonData(jsonData);
      addPolygonsToMap(polygonsData, controller);
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carte avec Polygone et Cercles'),
      ),
      body: MapboxMap(
        accessToken:
            "pk.eyJ1IjoidmVpbGxlY28iLCJhIjoiY2tmbzFmNnJ4MDNibzJwcGZrb3psanhqMSJ9.Y-zA_n-3WWfvNDPfDYOISA", // Remplace par ton token
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _centreCarte,
          zoom: 15.0,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

// Fonction pour calculer le centre du polygone
LatLng calculatePolygonCenter(List<LatLng> polygonCoords) {
  double totalLat = 0;
  double totalLng = 0;

  for (var coord in polygonCoords) {
    totalLat += coord.latitude;
    totalLng += coord.longitude;
  }

  double centerLat = totalLat / polygonCoords.length;
  double centerLng = totalLng / polygonCoords.length;

  return LatLng(centerLat, centerLng);
}
