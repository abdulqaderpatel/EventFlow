import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Reusable_Components/User/user_details_field.dart';

import 'package:eventflow/Views/User/Profile/edit_user_profile.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Authentication/admin_or_user.dart';
import '../../Misc/Firebase/firebase_tables.dart';
import '../../Misc/toast/toast.dart';

class RandomUserProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const RandomUserProfileScreen(this.userData, {super.key});

  @override
  State<RandomUserProfileScreen> createState() =>
      _RandomUserProfileScreenState();
}

class _RandomUserProfileScreenState extends State<RandomUserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: Get.height,
            color: const Color(0xff111111),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.userData["name"],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: widget.userData["image"] == null
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
                                    widget.userData["image"],
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
                                  InkWell(
                                    child: Text(
                                      "0",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )
                                ],
                              ),
                              const Column(
                                children: [
                                  Text(
                                    "Following",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  InkWell(
                                    child: Text(
                                      "0",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400),
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
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseTable()
                                .usersTable
                                .where("id",
                                isEqualTo:
                                FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              List<ElevatedButton> clientWidgets = [];

                              if (snapshot.hasData) {
                                final clients = snapshot.data?.docs;
                                for (var client in clients!) {
                                  final clientWidget = client["following"]
                                      .contains(
                                      widget.userData["email"])
                                      ? ElevatedButton(
                                      onPressed: () {
                                        FirebaseTable().usersTable.doc(
                                            FirebaseAuth.instance.currentUser!
                                                .uid).update(
                                            {
                                              "following": FieldValue
                                                  .arrayRemove(
                                                  [widget.userData["email"]])
                                            });
                                        FirebaseTable()
                                            .usersTable.doc(
                                            widget.userData["id"]).update({"follower":FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!
                                            .email])});
                                      },
                                      child: Text("Unfollow"))
                                      :
                                  ElevatedButton(
                                      onPressed: () {
                                        FirebaseTable()
                                            .usersTable.doc(
                                            FirebaseAuth.instance.currentUser!
                                                .uid).update({"following":FieldValue.arrayUnion([widget.userData["email"]])});
                                        FirebaseTable()
                                            .usersTable.doc(
                                            widget.userData["id"]).update({"follower":FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!
                                            .email])});

                                      },
                                      child: Text("follow"));
                                  clientWidgets.add(clientWidget);
                                }
                              }
                              return Column(
                                children: clientWidgets,
                              );
                            }),
                        Row(
                          children: [
                            UserDetailField(
                                icon: Icons.supervised_user_circle,
                                placeholder: "username",
                                details: widget.userData["username"]),
                            SizedBox(
                              width: Get.width * 0.05,
                            ),
                            UserDetailField(
                                icon: Icons.email,
                                placeholder: "email",
                                details: widget.userData["email"]),
                          ],
                        ),
                        SizedBox(
                          height: Get.height * 0.05,
                        ),
                        Row(
                          children: [
                            UserDetailField(
                                icon: Icons.phone,
                                placeholder: "phone number",
                                details:
                                widget.userData["phone_number"].toString()),
                            SizedBox(
                              width: Get.width * 0.05,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
