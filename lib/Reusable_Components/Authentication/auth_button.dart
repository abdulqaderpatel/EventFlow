import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthButton extends StatelessWidget {
  final String name;
  final IconData icon;
  final TextEditingController controller;
  final bool obscureText;
  final bool? isAdmin;

  final String? Function(String?)  validator;

  AuthButton(
      {required this.name,
      required this.icon,
      required this.controller,
      required this.obscureText,
      this.isAdmin = false,

      required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value){

      },
      validator:validator,
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
          child: Icon(
            icon,
            color: isAdmin == true ? Colors.blue : Colors.red,
          ),
        ),
        hintText: name,
        hintStyle: const TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: Color(isAdmin == true ? 0xff3F00FF : 0xffff8b94),
            width: 1,
          ),
        ),
        filled: true,
        contentPadding: const EdgeInsets.all(16),
        fillColor: Color(isAdmin == true ? 0xff6495ED : 0xffff6b7a),
      ),
      controller: controller,
    );
  }
}
