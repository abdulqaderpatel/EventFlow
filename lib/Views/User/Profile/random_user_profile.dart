import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Reusable_Components/User/user_details_field.dart';



import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../Misc/Firebase/firebase_tables.dart';


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
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseTable()
                .usersTable
                .where("id",
                isEqualTo:
                widget.userData["id"])
                .snapshots(),
            builder: (context, snapshot) {
              List<SingleChildScrollView> clientWidgets =
              [];
              if (snapshot.hasData) {
                final clients = snapshot.data?.docs;
                for (var client in clients!) {
                  final clientWidget =
                  SingleChildScrollView(
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
                                          client["name"],
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
                                              child: Text(
                                                client["follower"].length.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w400),
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
                                              child: Text(
                                                client["following"].length.toString(),
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
                                  client["follower"]
                                      .contains(
                                      FirebaseAuth.instance.currentUser!.uid)
                                      ? ElevatedButton(
                                      onPressed: () {
                                        FirebaseTable().usersTable.doc(
                                            FirebaseAuth.instance.currentUser!
                                                .uid).update(
                                            {
                                              "following": FieldValue
                                                  .arrayRemove(
                                                  [client["id"]])
                                            });
                                        FirebaseTable()
                                            .usersTable.doc(
                                            client["id"]).update({"follower":FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!
                                            .uid])});

                                        FirebaseTable().usersTable.doc(client["id"]).update({"notification":FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.email])});
                                        FirebaseTable().usersTable.doc(client["id"]).collection("notifications").doc(FirebaseAuth.instance.currentUser!.uid).delete();
                                      },
                                      child: const Text("Unfollow"))
                                      :
                                  ElevatedButton(
                                      onPressed: () async {
                                        FirebaseTable()
                                            .usersTable.doc(
                                            FirebaseAuth.instance.currentUser!
                                                .uid).update({"following":FieldValue.arrayUnion([client["id"]])});
                                        FirebaseTable()
                                            .usersTable.doc(
                                            client["id"]).update({"follower":FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!
                                            .uid])});
                                        FirebaseTable().usersTable.doc(client["id"]).update({"notification":FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.email])});

                                        List<Map<String, dynamic>> items = [];



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
                                          });





                                        FirebaseTable().usersTable.doc(client["id"]).collection("notifications").doc(FirebaseAuth.instance.currentUser!.uid).set(
                                         items[0]

                                        );

                                      },
                                      child: const Text("follow")),
                                  Row(
                                    children: [
                                      UserDetailField(
                                          icon: Icons.supervised_user_circle,
                                          placeholder: "username",
                                          details: client["username"]),
                                      SizedBox(
                                        width: Get.width * 0.05,
                                      ),
                                      UserDetailField(
                                          icon: Icons.email,
                                          placeholder: "email",
                                          details: client["email"]),
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
                                          client["phone_number"].toString()),
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
                  );
                  clientWidgets.add(clientWidget);
                }
              }
              return Column(
                children: clientWidgets,
              );
            }
        ));
  }
}