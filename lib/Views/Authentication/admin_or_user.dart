
import 'package:eventflow/Views/Authentication/login.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AdminOrUserScreen extends StatelessWidget {
   const AdminOrUserScreen({super.key});

  final bool admin=true;
  final bool user=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      height: Get.height/1.2,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.to(LoginScreen(isAdmin: true));
              },
              child: const Text("Admin"),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(LoginScreen(isUser: true,));
              },
              child: const Text("User"),
            ),
          ],
        ),
      ),
    ));
  }
}
