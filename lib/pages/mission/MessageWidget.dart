// ignore: file_names
import 'package:clp_flutter/models/discussion.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final Discussion? message;

  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message?.isSender == true
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: message?.isSender == true ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: message?.texte != null
            ? Text(
                message!.texte,
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }
}
