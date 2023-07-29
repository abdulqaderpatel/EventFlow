import 'package:flutter/material.dart';


class UserTextField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final double width;
  final String labelText;

  final bool enabled;

  const UserTextField(
      {super.key,
      required this.text,
      required this.controller,
      required this.width,
        required this.labelText,

      this.enabled=true});

  @override
  Widget build(BuildContext context) {
    return text != "Description"
        ? SizedBox(
            height: 50,
            width: width,
            child: TextFormField(enabled: enabled,
              controller: controller,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(labelText: labelText,labelStyle: TextStyle(color: Colors.white),alignLabelWithHint: true,
                filled: true,
                fillColor: Colors.red,


                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 0.5),
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
                    borderSide: const BorderSide(
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
