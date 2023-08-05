import 'package:flutter/material.dart';

class CreateEventTextField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final double width;
  final String? labelText;
  final TextInputType textInputType;

  const CreateEventTextField({
    super.key,
    required this.text,
    required this.controller,
    required this.width,
    this.textInputType=TextInputType.text,
    this.labelText = null,
  });

  @override
  Widget build(BuildContext context) {
    return text != "Description"
        ? SizedBox(
            height: 50,
            width: width,
            child: TextFormField(keyboardType: textInputType,
              controller: controller,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                labelText: labelText,
                labelStyle: TextStyle(color: Colors.white),
                alignLabelWithHint: true,
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blue,),
                    borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.only(
                  top: 2,
                  left: 5,
                ),
                errorStyle: const TextStyle(fontSize: 0),
                hintStyle: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold),
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
                      color: Colors.blue,
                    ),
                    borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.only(top: 2, left: 3),
                errorStyle: const TextStyle(fontSize: 0),
                hintStyle: const TextStyle(
                  color: Colors.blueAccent,
                ),
                hintText: text,
              ),
            ),
          );
  }
}
