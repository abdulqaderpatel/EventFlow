import 'dart:io';

import 'package:eventflow/Controllers/Admins/admin_navigation_controller.dart';
import 'package:eventflow/Controllers/Users/user_navigation_controller.dart';
import 'package:eventflow/Views/Admin/Profile/admin_profile.dart';
import 'package:eventflow/Views/Admin/create_event.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart';

class AdminNavigationBar extends StatelessWidget {
  AdminNavigationBar({super.key});

  List<Widget> userPages = [
    CreateEventScreen(),
    const AdminProfileScreen(),
  ];

  File? eventImage;

  AdminNavigationController controller = Get.put(AdminNavigationController());


  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop:()async{
      return false;
    },
      child: Scaffold(
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(backgroundColor: Colors.blue,fixedColor: Colors.white,
            currentIndex: controller.index.value,
            onTap: (value) => controller.index.value = value,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: "Add Events",
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
          ),
        ),
        body: Obx(() => userPages[controller.index.value]),
      ),
    );
  }
}
