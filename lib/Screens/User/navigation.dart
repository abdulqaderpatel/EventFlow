import 'package:eventflow/Controllers/Users/navigation_controller.dart';
import 'package:eventflow/Screens/Authentication/Login.dart';
import 'package:eventflow/Screens/User/display_events.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class Navigation extends StatelessWidget {
  Navigation({super.key});

  List<Widget> userPages = [
    DisplayEventsScreen(),
    LoginScreen(),
    DisplayEventsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (value) => NavigationController().index.value = value,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: "Events",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: Obx(() => userPages[NavigationController().index.value]),
    );
  }
}
