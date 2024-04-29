import 'dart:convert';

import 'package:clp_flutter/pages/forgetPassword.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './collectes_liste.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../globals.dart' as globals;

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() {
    return _LogInScreen();
  }
}

class _LogInScreen extends State<LogInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login(String email, password) async {
    var headers = {
      'authorization': 'Basic c3R1ZHlkb3RlOnN0dWR5ZG90ZTEyMw==',
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    final body = {'email': 'marc.borgna@gmail.com', 'password': '1801'};
    // final body = {'email': 'melodidit@gmail.com', 'password': 'Colibri09'};

    try {
      Response response = await post(
          headers: headers,
          Uri.parse(
              'http://mesprojets-laravel.mborgna.vigilience.corp/api/clp/login'),
          // Uri.parse('https://la-gazette-eco.fr/api/clp/login'),
          body: jsonEncode(body));
      if (response.statusCode == 200) {
        var json = await jsonDecode(response.body);
        globals.user = json['nom'] + ' ' + json['prenom'];
        globals.token = json['token'];
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Collectes()));
      } else {
        print('NO NO NON ');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _sendMailForResetPassword(String email) async {
    var headers = {
      'authorization': 'Basic c3R1ZHlkb3RlOnN0dWR5ZG90ZTEyMw==',
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    final body = {'email': 'marc.borgna@gmail.com'};
    // final body = {'email': 'melodidit@gmail.com', 'password': 'Colibri09'};

    try {
      Response response = await post(
          headers: headers,
          Uri.parse(
              'http://mesprojets-laravel.mborgna.vigilience.corp/api/clp/forgetPassword'),
          body: jsonEncode(body));
      if (response.statusCode == 200) {
        var json = await jsonDecode(response.body);
      } else {
        print('NO NO NON ');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'Connectez-vous',
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
          Theme(
            data: ThemeData(
              hintColor: Colors.blue,
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 20, right: 20, left: 20),
              child: TextFormField(
                controller: passwordController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "password",
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
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    print('mot de passe');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgetPasswordScreen()));
                  },
                  child: Text(
                    'Mot de passe oublié ?',
                    style: TextStyle(
                        color: Color.fromARGB(255, 29, 86, 166), fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: GestureDetector(
                onTap: () {
                  login(emailController.text.toString(),
                      passwordController.text.toString());
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 29, 86, 166),
                      borderRadius: BorderRadius.circular(16)),
                  child: Center(child: Text('log in')),
                ),
              )),
          SizedBox(
            height: 50,
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account ?",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Sign up",
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
              Container(
                width: 55,
                height: 1,
                color: Colors.blue,
              )
            ],
          ),
        ],
      ),
    );
  }
}