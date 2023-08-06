import 'package:flutter/material.dart';

class AdminProfileSubmitButton extends StatelessWidget {
  final String text;
  final VoidCallback voidCallback;
  final bool isLoading;

  AdminProfileSubmitButton(
      {required this.text,
      required this.voidCallback,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(const Color(0xff0000ff)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      onPressed:voidCallback,

      child:!isLoading? Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ):const CircularProgressIndicator(),
    );
  }
}
