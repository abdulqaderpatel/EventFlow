import 'package:flutter/material.dart';


class AdminTextField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final double width;
  final String? labelText;
  final bool enabled;
  final bool isFilledColor;
  final String? Function(String?)  validator;
  final TextInputType textInputType;

  const AdminTextField(
      {super.key,
        required this.text,
        required this.controller,
        required this.width,
        this.labelText=null,
        this.isFilledColor=true,
        this.enabled=true,required  this.validator,this.textInputType=TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return text != "Description"
        ? SizedBox(
      height: 50,
      width: width,
      child: TextFormField(keyboardType:textInputType,enabled: enabled,
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(labelText: labelText,labelStyle: TextStyle(color: Colors.white),alignLabelWithHint: true,
          filled:isFilledColor? true:false,
          fillColor: Color
            (0xff0096FF),


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
      child: TextFormField(validator: validator,onChanged: (value){

      },
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
