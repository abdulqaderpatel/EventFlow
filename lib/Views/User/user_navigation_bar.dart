import 'package:eventflow/Controllers/Users/user_navigation_controller.dart';

import 'package:eventflow/Views/User/display_events.dart';
import 'package:eventflow/Views/User/search_friends.dart';
import 'package:eventflow/Views/User/Profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class UserNavigationBar extends StatelessWidget {
  UserNavigationBar({super.key});

  final List<Widget> userPages = [
    DisplayEventsScreen(),
    const SearchFriendsScreen(),
    const UserProfileScreen(),
  ];

  final UserNavigationController controller = Get.put(UserNavigationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(backgroundColor: Colors.red,
          currentIndex: controller.index.value,
          onTap: (value) => controller.index.value = value,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: "Events",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
      body: Obx(() => userPages[controller.index.value]),
    );
  }
}
