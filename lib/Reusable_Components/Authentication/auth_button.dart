import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthButton extends StatelessWidget {
  final String name;
  final IconData icon;
  final TextEditingController controller;
  final bool obscureText;
  const AuthButton(this.name, this.icon, this.controller, this.obscureText,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.justify,
      obscureText: obscureText,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(width: 2, color: Color(0xffff8b94))),
        prefixIcon: Container(
          height: Get.height * 0.069,
          width: Get.width * 0.13,
          margin: EdgeInsets.only(right: Get.width * 0.2),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          child: Icon(icon),
        ),
        hintText: name,
        hintStyle: const TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            color: Color(0xffff8b94),
            width: 1,
          ),
        ),
        filled: true,
        contentPadding: const EdgeInsets.all(16),
        fillColor: const Color(0xffff6b7a),
      ),
      controller: controller,
    );
  }
}
