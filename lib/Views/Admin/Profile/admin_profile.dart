import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Reusable_Components/User/user_details_field.dart';
import 'package:eventflow/Views/Admin/admin_events.dart';
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Authentication/admin_or_user.dart';
import '../../Misc/toast/toast.dart';
import 'edit_admin_profile.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final usernameController = TextEditingController();

  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final phoneNumberController = TextEditingController();

  FirebaseStorage storage = FirebaseStorage.instance;







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        color: const Color(0xff111111),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseTable()
                .adminsTable
                .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              List<Container> clientWidgets = [];
              if (snapshot.hasData) {
                final clients = snapshot.data?.docs;
                for (var client in clients!) {
                  final clientWidget = Container(
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 40, bottom: 20),
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
                                          await FirebaseAuth.instance.signOut();
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
                                            return const EditAdminProfileScreen();
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                  height: 40,
                                ),
                                UserDetailField(isLong: true,
                                    icon: Icons.supervised_user_circle,
                                    placeholder: "username",
                                    details: client["username"]),
                                SizedBox(height: Get.height*0.03,),
                                UserDetailField(
                                  isLong:true,
                                    icon: Icons.email,
                                    placeholder: "email",
                                    details: client["email"]),
                                SizedBox(
                                  height: Get.height * 0.03,
                                ),
                                Row(
                                  children: [
                                    UserDetailField(
                                        icon: Icons.phone,
                                        placeholder: "phone number",
                                        details:
                                            client["phone_number"].toString()),
                                    SizedBox(
                                      width: Get.width * 0.05,
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return const AdminEventsScreen();
                                      })),
                                      child: const UserDetailField(
                                        icon: Icons.event,
                                        placeholder: "Your events",
                                        details: "view",
                                        isIcon: true,
                                        textIcon: Icons.event,
                                      ),
                                    ),
                                  ],
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
    );
  }
}
