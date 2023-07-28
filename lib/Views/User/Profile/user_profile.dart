import 'dart:io';

import 'package:eventflow/Reusable_Components/User/user_details_field.dart';
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:eventflow/Views/Misc/toast/toast.dart';
import 'package:eventflow/Views/User/Profile/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

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

  void incrementCounter() async {
    List<Map<String, dynamic>> temp = [];
    var data = await FirebaseTable()
        .usersTable
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    for (var element in data.docs) {
      setState(() {
        temp.add(element.data());
      });
    }

    setState(() {
      items = temp;
      isLoaded = true;
    });

  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
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
                        padding: const EdgeInsets.all(30),
                        height: Get.height * 0.38,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15)),
                        width: Get.width,
                        child: Column(
                          children: [
                             Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                const Text(
                                  "Profile",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 22,fontWeight: FontWeight.w500),
                                ),
                                InkWell(onTap: ()=>Get.to(const EditProfileScreen()),
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
                                        items[0]["image"] ,
                                      ),
                                    ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Text(
                              items[0]["name"],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600),
                            )
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
