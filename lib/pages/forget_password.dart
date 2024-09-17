// ignore: file_names
// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

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
        const SnackBar(
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
            Uri.parse('https://www.la-gazette-eco.fr/api/clp/forgetPassword'),
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
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        // print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xff000725),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: 180,
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 29, 86, 166),
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(150))),
            child: const Padding(
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
          ),
          Theme(
            data: ThemeData(
              hintColor: Colors.blue,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
              child: TextFormField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  errorText: emailController.text.isEmpty
                      ? "Ce champ est obligatoire"
                      : null,
                  labelText: "email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 29, 86, 166), width: 1)),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 29, 86, 166), width: 1)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 29, 86, 166), width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 29, 86, 166), width: 1)),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: GestureDetector(
                onTap: () {
                  String name = emailController.text;
                  _sendMailForResetPassword(name);
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 29, 86, 166),
                      borderRadius: BorderRadius.circular(16)),
                  child: const Center(
                      child: Text('Envoyer un  mail de réinitialization')),
                ),
              )),
        ],
      ),
    );
  }
}
