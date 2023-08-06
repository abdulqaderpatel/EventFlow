import 'package:eventflow/Reusable_Components/User/user_details_field.dart';
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:eventflow/Views/User/Profile/edit_user_profile.dart';
import 'package:eventflow/Views/User/Profile/user_following_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Authentication/admin_or_user.dart';
import '../../Misc/toast/toast.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final usernameController = TextEditingController();

  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final phoneNumberController = TextEditingController();

  FirebaseStorage storage = FirebaseStorage.instance;

  late List<Map<String, dynamic>> items;
  bool isLoaded = false;

  late List<Map<String, dynamic>> followingItems;

  void incrementCounter() async {
    List<Map<String, dynamic>> followingTemp = [];

    var followingData = await FirebaseTable()
        .followingTable
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("userFollowing")
        .get();

    for (var element in followingData.docs) {
      followingTemp.add(element.data());
      print(followingTemp);
    }
    followingItems = followingTemp;

    List<Map<String, dynamic>> temp = [];
    var data = await FirebaseTable()
        .usersTable
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    for (var element in data.docs) {
      temp.add(element.data());

    }
    items = temp;

    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    incrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoaded
            ? SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 30),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15)),
                        width: Get.width,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const AdminOrUserScreen();
                                    }));
                                    Toast().successMessage(
                                        "Logged out successfully");
                                  },
                                  child: const Icon(
                                    Icons.logout,
                                    color: Colors.white,
                                  ),
                                  focusColor: Colors.blue,
                                ),
                                Text(
                                  items[0]["name"],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 23,
                                      fontWeight: FontWeight.w600),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const EditUserProfileScreen();
                                    }));
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: items[0]["image"] == null
                                      ? const CircleAvatar(
                                          radius: 60,
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.camera_alt,
                                            color: Colors.blue,
                                            size: 50,
                                          ),
                                        )
                                      : CircleAvatar(
                                          radius: 56,
                                          backgroundColor: Colors.white,
                                          backgroundImage: NetworkImage(
                                            items[0]["image"],
                                          ),
                                        ),
                                ),
                                const Column(
                                  children: [
                                    Text(
                                      "Followers",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "0",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      "Following",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return UserFollowingPageScreen(followingItems);
                                        }));
                                      },
                                      child: Text(
                                        followingItems.length.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      UserDetailField(
                          icon: Icons.verified_user,
                          placeholder: "username",
                          details: items[0]["username"]),
                      const SizedBox(
                        height: 30,
                      ),
                      UserDetailField(
                          icon: Icons.email,
                          placeholder: "email",
                          details: items[0]["email"]),
                      const SizedBox(
                        height: 30,
                      ),
                      UserDetailField(
                          icon: Icons.phone,
                          placeholder: "phone number",
                          details: items[0]["phone_number"].toString()),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
