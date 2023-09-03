import 'dart:io';

import 'package:eventflow/Controllers/Admins/admin_navigation_controller.dart';

import 'package:eventflow/Views/Admin/Profile/admin_profile.dart';
import 'package:eventflow/Views/Admin/create_event.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminNavigationBar extends StatelessWidget {
  AdminNavigationBar({super.key});

  final List<Widget> userPages = [
    const CreateEventScreen(),
    const AdminProfileScreen(),
  ];

  File? eventImage;

  final AdminNavigationController controller =
      Get.put(AdminNavigationController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: Obx(
              () =>  BottomNavigationBar(elevation: 0,backgroundColor:controller.index==1? const Color(0xff141414):const Color(0xff00141C),type: BottomNavigationBarType.fixed,selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.white,
            currentIndex: controller.index.value,
            onTap: (index) {
              controller.index.value=index;
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Add Events',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),

            ],
          ),
        ),
        body: Obx(() => userPages[controller.index.value]),
      ),
    );
  }
}
