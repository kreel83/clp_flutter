import 'package:flutter/material.dart';


class CustomDialogWidget extends StatelessWidget {
  final String title;
  final String content;
  final BuildContext context;

  // Déclaration du paramètre
  const CustomDialogWidget({super.key, required this.title, required this.content, required this.context});
  @override
  Widget build(BuildContext context) {

                              return AlertDialog(
                                title: Text(title
                                    ),
                                    content: Text(content),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Ok"))
                                ],
                              );
                         
  }
}



