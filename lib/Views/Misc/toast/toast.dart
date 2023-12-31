import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toast {
  void errorMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,

        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void successMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,

        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
