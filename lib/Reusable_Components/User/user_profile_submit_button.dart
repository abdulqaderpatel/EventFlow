import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfileSubmitButton extends StatelessWidget {

  final String text;
  final bool isLoading;
  final VoidCallback voidCallback;

  UserProfileSubmitButton({required this.text,this.isLoading=false,required this.voidCallback});


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color(0xffff0000)),
        foregroundColor: MaterialStateProperty.all<Color>(
            Colors.white),
      ),
      onPressed:voidCallback,
      child:!isLoading? Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ):CircularProgressIndicator()
    );
  }
}
