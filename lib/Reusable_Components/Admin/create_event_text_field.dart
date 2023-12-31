import 'package:flutter/material.dart';


class CreateEventTextField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final double width;
  final String? labelText;
  final TextInputType textInputType;
  final IconData? icon;

  const CreateEventTextField({
    super.key,
    required this.text,
    required this.controller,
    required this.width,
    this.textInputType=TextInputType.text,
    this.labelText,
    this.icon
  });

  @override
  Widget build(BuildContext context) {
    return text != "Description"
        ? Column(mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(" $text",style: const TextStyle(color: Color(0xff616161)),),
            SizedBox(
                height: 50,
                width: width,
                child: TextFormField(style: const TextStyle(color: Colors.white),keyboardType: textInputType,
                  controller: controller,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(suffixIcon: Icon(icon),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: const Color(0xff352D3C),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1, //<-- SEE HERE
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelStyle: const TextStyle(color: Colors.white),
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
              ),
          ],
        )
        : Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(" $text",style: const TextStyle(color: Color(0xff616161)),),
            SizedBox(
                height: 120,
                width: width,
                child: TextFormField(style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 5,
                  controller: controller,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: const Color(0xff352D3C),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1, //<-- SEE HERE
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelStyle: const TextStyle(color: Colors.white),
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
              ),
          ],
        );
  }
}
