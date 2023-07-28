import 'package:flutter/material.dart';

class UserTextField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final double width;
  final bool? isIcon;
  final IconData? icon;

  const UserTextField(
      {super.key,
      required this.text,
      required this.controller,
      required this.width,
      this.isIcon = false,
      this.icon = null});

  @override
  Widget build(BuildContext context) {
    return text != "Description"
        ? SizedBox(
            height: 50,
            width: width,
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.red,
                prefixIcon: isIcon == true ? Icon(icon) : null,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 0.5),
                    borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.only(
                  top: 2,
                  left: 5,
                ),
                errorStyle: const TextStyle(fontSize: 0),
                hintStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                hintText: text,
              ),
            ),
          )
        : SizedBox(
            height: 120,
            width: width,
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 5,
              controller: controller,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.only(top: 2, left: 3),
                errorStyle: const TextStyle(fontSize: 0),
                hintStyle: const TextStyle(
                  color: Colors.redAccent,
                ),
                hintText: text,
              ),
            ),
          );
  }
}
