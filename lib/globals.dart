library lge.globals;

import 'package:flutter/material.dart';

String user = "";
String token = "";
double espacement = 50;
Color mainColor = const Color.fromARGB(255, 63, 83, 99);

class Collecte {
  int status;
  int color;
  String name;

  Collecte({required this.status, required this.color, required this.name});
}

class Mission {
  String status;
  String name;
  int tarif;
  int color;
  String affichage;

  Mission(
      {required this.status,
      required this.name,
      required this.tarif,
      required this.color,
      required this.affichage});
}

List<Mission> missions = [
  Mission(
      status: "mairie",
      name: "Constat d'affichage\n mairie",
      color: 0xFFEF3535,
      tarif: 45,
      affichage: 'Mairie'),
  Mission(
      status: "terrain",
      name: "Constat d'affichage\n terrain",
      color: 0xFFFFA500,
      tarif: 25,
      affichage: 'Terrain'),
  Mission(
      status: "chantier",
      name: "Infos chantier / divers",
      color: 0xFF00FF84,
      tarif: 45,
      affichage: 'Chnatier'),
  Mission(
      status: "infos",
      name: "Remontée d'information CLP",
      color: 0xFFFF00E1,
      tarif: 0,
      affichage: 'Infos'),
];

List<Collecte> collectes = [
  Collecte(status: 1, color: 0xFFFFA500, name: "En cours"),
  Collecte(status: 2, color: 0xFFE6435E, name: "Annulée"),
  Collecte(status: 3, color: 0xFFE6435E, name: "Refusée"),
  Collecte(status: 4, color: 0xFF52AA52, name: "Validée"),
  Collecte(status: 5, color: 0xFF6495ED, name: "Payée"),
];

int getColorCollecte(int status) {
  for (var col in collectes) {
    if (col.status == status) return col.color;
  }
  return 0xFF;
}

Mission? getMissionAttribute(String? status) {
  for (var col in missions) {
    if (col.status == status) return col;
  }
  return null;
}

int getColorMission(String? status) {
  if (status == 'avalider') return 0xFFEDD664;
  if (status == 'valide') return 0xFF52AA52;
  return 0xFF4397E6;
}

String getAffichageMission(String? status) {
  for (var col in missions) {
    if (col.status == status) return col.name;
  }
  return "";
}

IconData getIconeMission(String? status) {
  if (status == 'avalider') return Icons.abc;
  if (status == 'valide') return Icons.check;
  return Icons.circle;
}
