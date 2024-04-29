import 'dart:convert';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './collectes_liste.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../globals.dart' as globals;

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreen();
}

class _ForgetPasswordScreen extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _sendMailForResetPassword(String email) async {
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Veuillez entrer du texte avant de soumettre."),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      var headers = {
        'authorization': 'Basic c3R1ZHlkb3RlOnN0dWR5ZG90ZTEyMw==',
        'Content-Type': 'application/json;charset=UTF-8',
        'Charset': 'utf-8'
      };

      final body = {'email': email};
      // final body = {'email': 'melodidit@gmail.com', 'password': 'Colibri09'};

      try {
        Response response = await post(
            headers: headers,
            Uri.parse(
                'http://mesprojets-laravel.mborgna.vigilience.corp/api/clp/forgetPassword'),
            body: jsonEncode(body));
        String message = "Le mail n'est pas reconnu";
        if (response.statusCode == 200) {
          var json = await jsonDecode(response.body);
          if (json['status'] == true) {
            message = "Le mail a bien été envoyé";
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          print('NO NO NON ');
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xff000725),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: 180,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 70, 20, 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'C.L.P',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  Text(
                    'Réinitialisation du mot de passe',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 29, 86, 166),
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(150))),
          ),
          Theme(
            data: ThemeData(
              hintColor: Colors.blue,
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 50, right: 20, left: 20),
              child: TextFormField(
                controller: emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  errorText: emailController.text.isEmpty
                      ? "Ce champ est obligatoire"
                      : null,
                  labelText: "email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 29, 86, 166), width: 1)),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 29, 86, 166), width: 1)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 29, 86, 166), width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 29, 86, 166), width: 1)),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: GestureDetector(
                onTap: () {
                  String name = emailController.text;
                  _sendMailForResetPassword(name);
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 29, 86, 166),
                      borderRadius: BorderRadius.circular(16)),
                  child: Center(
                      child: Text('Envoyer un  mail de réinitialization')),
                ),
              )),
        ],
      ),
    );
  }
}
