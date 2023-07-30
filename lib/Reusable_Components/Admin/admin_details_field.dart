import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AdminDetailsField extends StatelessWidget {
  final IconData icon;
  final String placeholder;
  final String details;

  const AdminDetailsField(
      {super.key, required this.icon, required this.placeholder, required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: Get.height * 0.12,

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,size: 25,color: Colors.blueAccent,
              ),
              const SizedBox(
                width: 5,
              ),
              Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 3),
                      child: Text(
                        placeholder,
                        style: const TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    details,
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 12,),
          const Expanded(
            child: Divider(
              color: Colors.blueAccent,
            ),
          )
        ],
      ),
    );
  }
}
