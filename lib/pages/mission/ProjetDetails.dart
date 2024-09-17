import 'package:clp_flutter/models/mission.dart';
import 'package:clp_flutter/pages/mapbox/FullMap.dart';
import 'package:flutter/material.dart';

class ProjetDetails extends StatelessWidget {
  final Map<String, dynamic> projet;
  final String adresse;
  final Mission mission;

  ProjetDetails(
      {required this.projet, required this.adresse, required this.mission});

  Widget BlocInfo(
      BuildContext context, String titre, valeur, int ligne, Color? color) {
    return Container(
      height: 80.0,
      width: ligne == 1
          ? double.infinity
          : MediaQuery.of(context).size.width * 0.45, // Largeur dynamique
      margin: EdgeInsets.symmetric(vertical: 5.0), // Marge verticale
      padding: EdgeInsets.all(10.0), // Padding interne
      decoration: BoxDecoration(
        color: color == null ? Colors.white : color, // Couleur de fond
        borderRadius: BorderRadius.circular(8.0), // Arrondir les coins
      ),
      child: (color == null)
          ? Column(
              children: [
                Text(
                  titre,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black26, // Texte en gris
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                if (valeur != 0)
                  Text(
                    valeur.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black, // Texte en gris
                    ),
                  ),
              ],
            )
          : Center(
              child: Text(titre),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocInfo(
            context, "Numéro de permis", projet['numero_de_permis'], 1, null),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocInfo(context, "Surface existante", projet['surface_existante'],
                2, null),
            BlocInfo(
                context, "Surface totale", projet['surface_totale'], 2, null),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocInfo(context, "Surface supprimée", projet['surface_supprimee'],
                2, null),
            BlocInfo(context, "Surface du terrain", projet['surface_terrain'],
                2, null),
          ],
        ),
        SizedBox(
          height: 30.0,
        ),
        Center(
          child: ElevatedButton.icon(
              icon: Icon(Icons.info, size: 16),
              label: Text('Voir la localisation'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CarteMapboxPage(mission: mission)));
              }),
        ),
      ],
    );
  }
}
