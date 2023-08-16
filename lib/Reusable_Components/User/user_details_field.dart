import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDetailField extends StatelessWidget {
  final IconData icon;
  final String placeholder;
  final String details;
  final VoidCallback? voidCallback;

  const UserDetailField(
      {super.key,
      required this.icon,
      required this.placeholder,
      required this.details,
      this.voidCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.15,
      width: Get.width * 0.45,
      padding: const EdgeInsets.only(
        top: 8,
        left: 8,
        right: 8,
        bottom: 20,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                placeholder,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
              Icon(
                icon,
                color: Colors.blueGrey,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: voidCallback,
                child: AutoSizeText(
                  details,
                  maxLines: 1,
                  minFontSize: 13,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
