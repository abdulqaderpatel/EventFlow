import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Views/User/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Misc/Firebase/firebase_tables.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff00141C),
        title: const Text("Notifications"),
      ),
      body: Container(
        color: const Color(0xff0A171F),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.78,
                  child: ListView(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseTable()
                              .usersTable
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("notifications")
                              .snapshots(),
                          builder: (context, snapshot) {
                            List<Container> clientWidgets = [];
                            if (snapshot.hasData) {
                              final clients = snapshot.data?.docs;
                              for (var client in clients!) {
                                final clientWidget = Container(
                                  child: InkWell(
                                    onTap: () {},
                                    child: Card(
                                        margin:
                                            const EdgeInsets.only(bottom: 20),
                                        color: const Color(0xff0A171F),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 40,
                                                  child: ClipRect(
                                                      child: Image.network(
                                                          client["image"],
                                                          fit: BoxFit.contain)),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${client['name']} has started following you. ",
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    const Text(
                                                      "Follow them back to chat with them",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    FirebaseTable().usersTable.doc(FirebaseAuth.instance.currentUser!.uid).update({"following":FieldValue.arrayUnion([client["id"]])});
                                                    FirebaseTable().usersTable.doc(client["id"]).update({"follower":FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])});
                                                    FirebaseTable().usersTable.doc(FirebaseAuth.instance.currentUser!.uid).collection("notifications").doc(client["id"]).delete();
                                                  },
                                                  child:
                                                      const Text("Follow back"),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.blue),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    FirebaseTable().usersTable.doc(FirebaseAuth.instance.currentUser!.uid).collection("notifications").doc(client["id"]).delete();
                                                  },
                                                  child: const Text("Cancel"),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.red),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ),
                                );
                                clientWidgets.add(clientWidget);
                              }
                            }
                            return Column(
                              children: clientWidgets,
                            );
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
