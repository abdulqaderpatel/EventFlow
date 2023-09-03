import 'package:eventflow/Controllers/Users/user_navigation_controller.dart';

import 'package:eventflow/Views/User/display_events.dart';
import 'package:eventflow/Views/User/search_friends.dart';
import 'package:eventflow/Views/User/Profile/user_profile.dart';
import 'package:eventflow/Views/User/select_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';




class UserNavigationBar extends StatelessWidget {
  UserNavigationBar({super.key});

  final List<Widget> userPages = [
    const DisplayEventsScreen(),
    const SearchFriendsScreen(),
    const SelectChatScreen(),
    const UserProfileScreen(),
  ];

  final UserNavigationController controller =
  Get.put(UserNavigationController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: Obx(
              () =>  BottomNavigationBar(elevation: 0,backgroundColor:controller.index==3? Color(0xff141414):Color(0xff00141C),type: BottomNavigationBarType.fixed,selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.white,
            currentIndex: controller.index.value,
            onTap: (index) {
              controller.index.value=index;
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Chat',
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