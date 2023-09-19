import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Views/User/chat_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Misc/Firebase/firebase_tables.dart';
import '../event_details.dart';

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
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseTable()
              .usersTable
              .where("id", isEqualTo: widget.userData["id"])
              .snapshots(),
          builder: (context, snapshot) {
            List<SingleChildScrollView> clientWidgets = [];
            if (snapshot.hasData) {
              final clients = snapshot.data?.docs;
              for (var client in clients!) {
                final clientWidget = SingleChildScrollView(
                  child: Container(
                    height: Get.height,
                    color: const Color(0xff111111),
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              top: 40,
                            ),
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
                                      Container(),
                                      Text(
                                        client["name"],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 23,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      client["follower"].contains(FirebaseAuth
                                                  .instance.currentUser!.uid) &&
                                              client["following"].contains(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid)
                                          ? InkWell(
                                              onTap: () {
                                                List<String> ids = [
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  widget.userData["id"]
                                                ];
                                                ids.sort();
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return ChatScreen(
                                                      ids.join("_"),
                                                      widget.userData);
                                                }));
                                              },
                                              child: const Icon(
                                                Icons.chat,
                                                color: Colors.white,
                                              ))
                                          : Container()
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
                                            child: Text(
                                              client["follower"]
                                                  .length
                                                  .toString(),
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
                                              client["following"]
                                                  .length
                                                  .toString(),
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
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.02),
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                client["follower"].contains(
                                        FirebaseAuth.instance.currentUser!.uid)
                                    ? ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            minimumSize: Size(Get.width, 40), backgroundColor: Colors.red,
                                            textStyle: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight
                                                    .w500) // Background color
                                            ),
                                        onPressed: () {
                                          FirebaseTable()
                                              .usersTable
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .update({
                                            "following": FieldValue.arrayRemove(
                                                [client["id"]])
                                          });
                                          FirebaseTable()
                                              .usersTable
                                              .doc(client["id"])
                                              .update({
                                            "follower": FieldValue.arrayRemove([
                                              FirebaseAuth
                                                  .instance.currentUser!.uid
                                            ])
                                          });

                                          FirebaseTable()
                                              .usersTable
                                              .doc(client["id"])
                                              .update({
                                            "notification":
                                                FieldValue.arrayRemove([
                                              FirebaseAuth
                                                  .instance.currentUser!.email
                                            ])
                                          });
                                          FirebaseTable()
                                              .usersTable
                                              .doc(client["id"])
                                              .collection("notifications")
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .delete();
                                        },
                                        child: const Text("Unfollow"))
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            minimumSize: Size(Get.width, 40), backgroundColor: Colors.green,
                                            textStyle: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight
                                                    .w500) // Background color
                                            ),
                                        onPressed: () async {
                                          FirebaseTable()
                                              .usersTable
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .update({
                                            "following": FieldValue.arrayUnion(
                                                [client["id"]])
                                          });
                                          FirebaseTable()
                                              .usersTable
                                              .doc(client["id"])
                                              .update({
                                            "follower": FieldValue.arrayUnion([
                                              FirebaseAuth
                                                  .instance.currentUser!.uid
                                            ])
                                          });
                                          FirebaseTable()
                                              .usersTable
                                              .doc(client["id"])
                                              .update({
                                            "notification":
                                                FieldValue.arrayUnion([
                                              FirebaseAuth
                                                  .instance.currentUser!.email
                                            ])
                                          });

                                          List<Map<String, dynamic>> items = [];

                                          List<Map<String, dynamic>> temp = [];
                                          var data = await FirebaseTable()
                                              .usersTable
                                              .where("email",
                                                  isEqualTo: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .email)
                                              .get();

                                          for (var element in data.docs) {
                                            setState(() {
                                              temp.add(element.data());
                                            });
                                          }
                                          setState(() {
                                            items = temp;
                                          });

                                          FirebaseTable()
                                              .usersTable
                                              .doc(client["id"])
                                              .collection("notifications")
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .set(items[0]);
                                        },
                                        child: const Text("follow")),
                                const SizedBox(height: 15),
                                const Icon(
                                  Icons.event,
                                  color: Colors.grey,
                                  size: 28,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SingleChildScrollView(
                                  child: SizedBox(
                                    height: Get.height * 0.50,
                                    child: ListView(
                                      children: [
                                        StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseTable()
                                                .eventsTable
                                                .where("emails",
                                                    arrayContains: widget
                                                        .userData["email"])
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              List<InkWell> clientWidgets = [];
                                              if (snapshot.hasData) {
                                                final clients =
                                                    snapshot.data?.docs;
                                                for (var client in clients!) {


                                                  final clientWidget = InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                          return EventDetailsScreen({
                                                            "admin_image": client[
                                                                "admin_image"],
                                                            "description": client[
                                                                "description"],
                                                            "emails": client[
                                                                "emails"],
                                                            "end_time": client[
                                                                "end_time"],
                                                            "event_creator": client[
                                                                "event_creator"],
                                                            "id": client["id"],
                                                            "image":
                                                                client["image"],
                                                            "location": client[
                                                                "location"],
                                                            "max_participants":
                                                                client[
                                                                    "max_participants"],
                                                            "name":
                                                                client["name"],
                                                            "participants": client[
                                                                "participants"],
                                                            "price":
                                                                client["price"],
                                                            "start_time": client[
                                                                "start_time"],
                                                            "username": client[
                                                                "username"],
                                                            "rating": client[
                                                                "rating"],
                                                          });
                                                        }),
                                                      );
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            gradient:
                                                                const LinearGradient(
                                                              colors: [
                                                                Colors.black,
                                                                Color(
                                                                    0xff4D4855)
                                                              ],
                                                              begin: Alignment
                                                                  .bottomLeft,
                                                              end: Alignment
                                                                  .topRight,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              20,
                                                            ),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Stack(
                                                                children: [
                                                                  Container(
                                                                    height: Get
                                                                            .height *
                                                                        0.275,
                                                                    width: Get
                                                                        .width,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20)),
                                                                    child: ClipRRect(
                                                                        borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                                                                        child: Image.network(
                                                                          client[
                                                                              "image"],
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        )),
                                                                  ),
                                                                  Positioned(
                                                                    top: Get.height *
                                                                        0.025,
                                                                    right: Get
                                                                            .width *
                                                                        0.076,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          60,
                                                                      width: 60,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: const Color(0xff65696E)
                                                                            .withOpacity(0.4),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              DateFormat("d").format(
                                                                                DateTime.parse(
                                                                                  client["start_time"],
                                                                                ),
                                                                              ),
                                                                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                                                            ),
                                                                            Text(
                                                                              DateFormat("MMMM").format(
                                                                                DateTime.parse(
                                                                                  client["start_time"],
                                                                                ),
                                                                              ),
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 10),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        20,
                                                                    horizontal:
                                                                        10),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: Get
                                                                              .width *
                                                                          0.65,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                client["name"],
                                                                                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                client["location"],
                                                                                style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                                                                              ),
                                                                              Text(
                                                                                " - ${DateFormat("hh:mm a").format(
                                                                                  DateTime.parse(
                                                                                    client["start_time"],
                                                                                  ),
                                                                                )}",
                                                                                style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              4),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              20),
                                                                          color:
                                                                              Colors.white),
                                                                      child:
                                                                          Text(
                                                                        "₹ ${client["price"]}",
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              Get.height * 0.03,
                                                        )
                                                      ],
                                                    ),
                                                  );

                                                  clientWidgets
                                                      .add(clientWidget);
                                                }
                                              }
                                              return Column(
                                                children: clientWidgets,
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                )
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
          }),
    ));
  }
}
