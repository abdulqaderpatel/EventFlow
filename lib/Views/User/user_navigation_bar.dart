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
          () => Container(color: Color(0xff0A171F),

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
              child: GNav(selectedIndex: controller.index.value,
                onTabChange: (value)
                {
                  controller.index.value=value;
                },
                backgroundColor:Color(0xff0A171F),
                gap: 8,
                activeColor: Colors.white,



                color: Colors.white,

                padding: const EdgeInsets.all(5),

                 tabs:const [ GButton(
                   icon: Icons.home_filled,
                 iconActiveColor: Color(0xffFB5188),


                 ),
                   GButton(
                     active: true,
                     icon: Icons.search,
                   iconActiveColor: Color(0xffFB5188),

                   ),
                   GButton(
                     icon:Icons.chat_bubble,
                   iconActiveColor: Color(0xffFB5188),

                   ),
                   GButton(
                     icon: Icons.person,
                   iconActiveColor: Color(0xffFB5188),

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
