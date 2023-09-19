import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDetailField extends StatelessWidget {
  final IconData icon;
  final String placeholder;
  final String details;
  final VoidCallback? voidCallback;
  final bool? isIcon;
  final IconData? textIcon;
  final bool isLong;

  const UserDetailField(
      {super.key,
      required this.icon,
      required this.placeholder,
      required this.details,
      this.isIcon = false,
        this.isLong=false,
      this.voidCallback,
      this.textIcon});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: Get.height * 0.11,
        width:isLong?Get.width: Get.width * 0.45,
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
               Text(
                  placeholder,
                  maxLines: 1,
                  style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                Icon(
                  icon,
                  color: Colors.blueGrey,
                ),
              ],
            ),
            Row(
              mainAxisAlignment:isLong?MainAxisAlignment.start: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: voidCallback,
                    child: !isIcon!
                        ? Text(
                            details,
                            maxLines: 2,
                            style: TextStyle(
                                overflow: TextOverflow.clip,
                                color: Colors.white,
                                fontSize: isLong?16:14,
                                fontWeight: FontWeight.w500),
                          )
                        : Icon(
                            textIcon,
                            color: Colors.white,
                          ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
