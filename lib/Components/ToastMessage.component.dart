import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessageComponent {
  static void show({
    required String message,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Toast length = Toast.LENGTH_LONG,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: length,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }

  // 🚀 atalhos prontos (pra não repetir cor nunca mais)
  static void success(String message) {
    show(message: message, backgroundColor: Colors.green);
  }

  static void error(String message) {
    show(message: message, backgroundColor: Colors.red);
  }

  static void warning(String message) {
    show(message: message, backgroundColor: Colors.orange);
  }

  static void info(String message) {
    show(message: message, backgroundColor: Colors.blue);
  }
}
