import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Reusable_Components/User/user_details_field.dart';
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:eventflow/Views/User/Profile/edit_user_profile.dart';
import 'package:eventflow/Views/User/Profile/user_follower_page.dart';
import 'package:eventflow/Views/User/Profile/user_following_page.dart';
import 'package:eventflow/Views/User/user_enrolled_events.dart';
import 'package:eventflow/Views/User/user_reciepts.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color(0xff111111),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseTable()
                  .usersTable
                  .where("id",
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                List<Container> clientWidgets = [];
                if (snapshot.hasData) {
                  final clients = snapshot.data?.docs;
                  for (var client in clients!) {
                    final clientWidget = Container(
                      color: const Color(0xff111111),
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0, bottom: 20),
                              decoration: const BoxDecoration(
                                color: Color(0xff111111),
                              ),
                              width: Get.width,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            await FirebaseAuth.instance
                                                .signOut();
                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return const AdminOrUserScreen();
                                            }));
                                            Toast().successMessage(
                                                "Logged out successfully");
                                          },
                                          focusColor: Colors.blue,
                                          child: const Icon(
                                            Icons.logout,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          client["name"],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 23,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
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
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: client["image"] == null
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
                                                    client["image"],
                                                  ),
                                                ),
                                        ),
                                        Column(
                                          children: [
                                            const Text(
                                              "Followers",
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
                                                  return UserFollowerScreen();
                                                }));
                                              },
                                              child: Text(
                                                client["follower"]
                                                    .length
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
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
                                                  return UserFollowingScreen();
                                                }));
                                              },
                                              child: Text(
                                                client["following"]
                                                    .length
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Get.width * 0.02),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),

                                      Row(
                                        children: [
                                          UserDetailField(isLong: true,
                                              icon: Icons.supervised_user_circle,
                                              placeholder: "username",
                                              details: client["username"]),
                                        ],
                                      ),
                                  SizedBox(
                                    height: Get.height * 0.03,
                                  ),
                                      SizedBox(
                                        width: Get.width * 0.05,
                                      ),
                                      Row(
                                        children: [
                                          UserDetailField(
                                            isLong: true,
                                              icon: Icons.email,
                                              placeholder: "email",
                                              details: client["email"]),
                                        ],
                                      ),

                                  SizedBox(
                                    height: Get.height * 0.03,
                                  ),
                                  Row(
                                    children: [
                                      UserDetailField(
                                          icon: Icons.phone,
                                          placeholder: "phone number",
                                          details: client["phone_number"]
                                              .toString()),
                                      SizedBox(
                                        width: Get.width * 0.05,
                                      ),
                                      InkWell(
                                        onTap: () => Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return UserEnrolledEventsScreen();
                                        })),
                                        child: const UserDetailField(
                                          icon: Icons.event,
                                          placeholder: "Enrolled events",
                                          details: "view",
                                          isIcon: true,
                                          textIcon: Icons.event,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.05,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size(Get.width * 0.9, 40),
                                        backgroundColor: Colors.red,
                                        textStyle: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight
                                                .w500) // Background color
                                        ),
                                    onPressed: () {
                                      Get.to(UserRecieptsScreen());
                                    },
                                    child: const Text("Your Reciepts"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                    clientWidgets.add(clientWidget);
                  }
                } else {
                  final clientWidget = Container(
                    color: const Color(0xff111111),
                  );
                  clientWidgets.add(clientWidget);
                }

                return Column(
                  children: clientWidgets,
                );
              }),
        ),
      ),
    );
  }
}
