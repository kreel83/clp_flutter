import 'package:flutter/material.dart';
import './../globals.dart' as globals;

class CenterMessageWidget extends StatelessWidget {
  final String texte;

  // Déclaration du paramètre
  const CenterMessageWidget({super.key, required this.texte});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: globals.mainColor,
          border: Border.all(
            color: Colors.yellow.shade700,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          texte,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
