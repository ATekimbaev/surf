import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/main.dart';

class ShowMessages {
  
  static showBar(
      {required String message,
      Color color = Colors.grey,
      required Duration duration}) {

        
    globalKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: color,
        duration: duration,
        content: Text(message),
      ),
    );
  }
}