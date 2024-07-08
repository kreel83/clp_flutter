import 'dart:convert';
import 'package:clp_flutter/pages/forget_password.dart';
import 'package:clp_flutter/utils/dialog.dart';
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
  bool _obscureText = true;

  void login(String email, password) async {
    var headers = {
      'authorization': 'Basic c3R1ZHlkb3RlOnN0dWR5ZG90ZTEyMw==',
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    // final body = {'email': 'marc.borgna@gmail.com', 'password': '1801'};
    // final body = {'email': 'melodidit@gmail.com', 'password': 'Colibri09'};
    final body = {'email': email, 'password': password};
    try {
      Response response = await post(
          headers: headers,
          Uri.parse('https://www.la-gazette-eco.fr/api/clp/login'),
          // Uri.parse('https://la-gazette-eco.fr/api/clp/login'),
          body: jsonEncode(body));
      if (response.statusCode == 200) {
        var json = await jsonDecode(response.body);
        if (json['token'] == 'none') {
          showDialog(
              // ignore: use_build_context_synchronously
              context: context,
              builder: (BuildContext context) {
                return CustomDialogWidget(
                  title: 'Attention',
                  content: 'Identifiant ou mot de passe ne correspondent pas',
                  context: context,
                );
              });
        } else {
          globals.user = json['nom'] + ' ' + json['prenom'];
          globals.token = json['token'];
          Navigator.pushReplacement(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (context) => const Collectes()));
        }
      } else {
        // print('NO NO NON ');
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  // void _sendMailForResetPassword(String email) async {
  //   var headers = {
  //     'authorization': 'Basic c3R1ZHlkb3RlOnN0dWR5ZG90ZTEyMw==',
  //     'Content-Type': 'application/json;charset=UTF-8',
  //     'Charset': 'utf-8'
  //   };

  //   final body = {'email': 'marc.borgna@gmail.com'};
  //   final body = {'email': 'melodidit@gmail.com', 'password': 'Colibri09'};

  //   try {
  //     await post(
  //         headers: headers,
  //         Uri.parse(
  //             'https://www.la-gazette-eco.fr/api/clp/forgetPassword'),
  //         body: jsonEncode(body));
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000725),
      body: Center(
        child: Column(
          children: [
            Center(
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 87, 149, 234),
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
                    ],
                  ),
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
            Theme(
              data: ThemeData(
                hintColor: Colors.blue,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: TextFormField(
                  obscureText: _obscureText,
                  controller: passwordController,
                  // keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
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
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgetPasswordScreen()));
                    },
                    child: const Text(
                      'Mot de passe oublié ?',
                      style: TextStyle(
                          color: Color.fromARGB(255, 29, 86, 166),
                          fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: GestureDetector(
                  onTap: () {
                    (emailController.text.toString() == '' ||
                            passwordController.text.toString() == "")
                        ? showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialogWidget(
                                title: 'Attention',
                                content:
                                    'Vous devez renseigner les deux champs',
                                context: context,
                              );
                            })
                        : login(emailController.text.toString(),
                            passwordController.text.toString());
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 29, 86, 166),
                        borderRadius: BorderRadius.circular(16)),
                    child: const Center(
                        child: Text(
                      'Se connecter',
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                )),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
