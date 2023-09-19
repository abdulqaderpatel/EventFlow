
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileSubmitButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback voidCallback;

  const UserProfileSubmitButton(
      {super.key, required this.text, this.isLoading = false, required this.voidCallback});

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.bottomCenter,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(  shape:
          RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
      side: const BorderSide(color: Colors.red)), backgroundColor: const Color(0xffFE7A3E)
      ,minimumSize: Size(Get.width, 40),textStyle: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500) // Background color
          ),
          onPressed: voidCallback,
          child: !isLoading
              ? Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : const CircularProgressIndicator()),
    );
  }
}
