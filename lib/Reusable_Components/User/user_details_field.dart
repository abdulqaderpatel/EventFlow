import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDetailField extends StatelessWidget {
  final IconData icon;
  final String placeholder;
  final String details;

  const UserDetailField(
      {super.key,
      required this.icon,
      required this.placeholder,
      required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.15,
      width: Get.width * 0.45,
      padding: const EdgeInsets.all(
        8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff1C1C1E),
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
               placeholder,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
              Icon(icon,color: Colors.blueGrey,),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                details,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w600),
              )
            ],
          )
        ],
      ),
    );
  }
}
