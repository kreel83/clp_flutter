import 'package:clp_flutter/pages/mapbox/FullMap.dart';
import 'package:flutter/material.dart';
import './pages/login.dart';
import 'package:flutter/services.dart';
import './globals.dart' as globals;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root o∏f your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application CLP',
      theme: ThemeData(
// Définir les couleurs principales de l'application
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],

        // Définir les styles de texte
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),

        // Définir le thème des boutons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: globals.mainColor, // Couleur du texte
          ),
        ),

        // Définir le thème des AppBar
        appBarTheme: AppBarTheme(
            color: globals.mainColor,
            titleTextStyle:
                const TextStyle(fontSize: 20.0, color: Colors.white),
            iconTheme: const IconThemeData(
              color: Colors.white,
            )),

        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: globals.mainColor, foregroundColor: Colors.white),

        // Définir le thème de la barre de navigation inférieure
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: globals.mainColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[400],
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        ),
      ),
      home: const LogInScreen(),
      //home: CarteMapboxPage(),
    );
  }
}
