import 'package:flutter/material.dart';

class UserTextField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final double width;
  final String labelText;
  final TextInputType textInputType;

  final bool enabled;
  final String? Function(String?) validator;

  const UserTextField(
      {super.key,
      required this.text,
      required this.controller,
      required this.width,
      required this.labelText,
      required this.validator,
      this.textInputType = TextInputType.text,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return text != "Description"
        ? SizedBox(
            height: 50,
            width: width,
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              keyboardType: textInputType,
              validator: validator,
              enabled: enabled,
              controller: controller,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: labelText,
                labelStyle: const TextStyle(color: Colors.grey),
                alignLabelWithHint: true,
                contentPadding: const EdgeInsets.only(
                  top: 2,
                  left: 5,
                ),
                errorStyle: const TextStyle(fontSize: 0),
                hintStyle: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.w400),
                hintText: text,
              ),
            ),
          )
        : SizedBox(
            height: 120,
            width: width,
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 5,
              controller: controller,
              decoration: InputDecoration(
                enabledBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.only(top: 2, left: 3),
                hintText: text,
                hintStyle: const TextStyle(color: Colors.white),
              ),
            ),
          );
  }
}
