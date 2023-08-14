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
          () => Container(color: Color(0xff060E11),

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
              child: GNav(selectedIndex: controller.index.value,
                onTabChange: (value)
                {
                  controller.index.value=value;
                },
                backgroundColor:Color(0xff060E11),
                gap: 8,
                activeColor: Colors.white,

                color: Colors.white,
                tabBackgroundColor: Colors.grey.shade900,
                padding: const EdgeInsets.all(5),

                 tabs:const [ GButton(
                   icon: Icons.event,
                  text: "Events",
                 ),
                   GButton(
                     icon: Icons.search,
                    text: "Search",
                   ),
                   GButton(
                     icon: Icons.chat,
                    text: "Chat",
                   ),
                   GButton(
                     icon: Icons.person,
                    text: "Profile",
                   ),],
              ),
            ),
          ),
        ),
        body: Obx(() => userPages[controller.index.value]),
      ),
    );
  }
}
