import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:intl/intl.dart';

import 'admin_event_details.dart';

class AdminEventsScreen extends StatefulWidget {
  const AdminEventsScreen({super.key});

  @override
  State<AdminEventsScreen> createState() => _AdminEventsScreenState();
}

class _AdminEventsScreenState extends State<AdminEventsScreen> {
  List<String> categoryTypes = ["Ongoing", "finished"];
  List<String> categoryImages = [
    "assets/images/mountain.jpeg",
    "assets/images/timepass3.jpg"
  ];
  int currentIndex = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          height: Get.height,
          color: const Color(0xff00141C),
          padding:
              EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        currentIndex = 0;
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 20),
                          height: 100,
                          width: 130,
                          decoration: BoxDecoration(
                              border: currentIndex == 0
                                  ? Border.all(width: 2, color: Colors.grey)
                                  : null,
                              gradient: const LinearGradient(colors: [
                                Color(0xffF907FC),
                                Color(0xff05D6D9)
                              ]),
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.red),
                          child: Stack(
                            children: [
                              Center(
                                  child: Text(
                                    categoryTypes[0],
                                    style: TextStyle(
                                        color: currentIndex == 0
                                            ? Colors.white54
                                            : Colors.grey),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        currentIndex = 1;
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 20),
                          height: 100,
                          width: 130,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Color(0xffFF0000),
                                Color(0xffFF7878)
                              ]),
                              border: currentIndex == 1
                                  ? Border.all(width: 2, color: Colors.grey)
                                  : null,
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.red),
                          child: Stack(
                            children: [
                              Center(
                                  child: Text(
                                    categoryTypes[1],
                                    style: TextStyle(
                                        color: currentIndex == 1
                                            ? Colors.white54
                                            : Colors.grey),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Container(
                height: Get.height * 0.75,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListView(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseTable().eventsTable.where("event_creator",isEqualTo:FirebaseAuth.instance.currentUser!.displayName).snapshots(),
                        builder: (context, snapshot) {
                          List<InkWell> clientWidgets = [];
                          if (snapshot.hasData) {
                            final clients = snapshot.data?.docs;
                            for (var client in clients!) {
                              final clientWidget = currentIndex == 1
                                  ? (DateTime.now().isAfter(
                                          DateTime.parse(client["end_time"]))
                                      ? InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                return AdminEventDetailsScreen({
                                                  "admin_image":
                                                      client["admin_image"],
                                                  "description":
                                                      client["description"],
                                                  "emails": client["emails"],
                                                  "end_time":
                                                      client["end_time"],
                                                  "event_creator":
                                                      client["event_creator"],
                                                  "id": client["id"],
                                                  "image": client["image"],
                                                  "location":
                                                      client["location"],
                                                  "max_participants": client[
                                                      "max_participants"],
                                                  "name": client["name"],
                                                  "participants":
                                                      client["participants"],
                                                  "price": client["price"],
                                                  "start_time":
                                                      client["start_time"],
                                                  "username":
                                                      client["username"],
                                                });
                                              }),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  gradient: const LinearGradient(
                                                    colors: [
                                                      Colors.black,
                                                      Color(0xff4D4855)
                                                    ],
                                                    begin: Alignment.bottomLeft,
                                                    end: Alignment.topRight,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    20,
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        Container(
                                                          height: Get.height *
                                                              0.275,
                                                          width: Get.width,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child: ClipRRect(
                                                              borderRadius: const BorderRadius
                                                                      .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20)),
                                                              child:
                                                                  Image.network(
                                                                client["image"],
                                                                fit: BoxFit
                                                                    .cover,
                                                              )),
                                                        ),
                                                        Positioned(
                                                          top: Get.height *
                                                              0.025,
                                                          right:
                                                              Get.width * 0.076,
                                                          child: Container(
                                                            height: 60,
                                                            width: 60,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: const Color(
                                                                      0xff65696E)
                                                                  .withOpacity(
                                                                      0.4),
                                                            ),
                                                            child: Center(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    DateFormat(
                                                                            "d")
                                                                        .format(
                                                                      DateTime
                                                                          .parse(
                                                                        client[
                                                                            "start_time"],
                                                                      ),
                                                                    ),
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                  Text(
                                                                    DateFormat(
                                                                            "MMMM")
                                                                        .format(
                                                                      DateTime
                                                                          .parse(
                                                                        client[
                                                                            "start_time"],
                                                                      ),
                                                                    ),
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize:
                                                                            10),
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
                                                          vertical: 20,
                                                          horizontal: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            width: Get.width *
                                                                0.65,
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      client[
                                                                          "name"],
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      client[
                                                                          "location"],
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                    Text(
                                                                      " - ${DateFormat("hh:mm a").format(
                                                                        DateTime
                                                                            .parse(
                                                                          client[
                                                                              "start_time"],
                                                                        ),
                                                                      )}",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: Colors
                                                                    .white),
                                                            child: Text(
                                                              "₹ ${client["price"]}",
                                                              style: const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: Get.height * 0.03,
                                              )
                                            ],
                                          ),
                                        )
                                      : InkWell(
                                          child: Container(),
                                        ))
                                  : (DateTime.now().isBefore(
                                          DateTime.parse(client["end_time"]))
                                      ? InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                return AdminEventDetailsScreen({
                                                  "admin_image":
                                                      client["admin_image"],
                                                  "description":
                                                      client["description"],
                                                  "emails": client["emails"],
                                                  "end_time":
                                                      client["end_time"],
                                                  "event_creator":
                                                      client["event_creator"],
                                                  "id": client["id"],
                                                  "image": client["image"],
                                                  "location":
                                                      client["location"],
                                                  "max_participants": client[
                                                      "max_participants"],
                                                  "name": client["name"],
                                                  "participants":
                                                      client["participants"],
                                                  "price": client["price"],
                                                  "start_time":
                                                      client["start_time"],
                                                  "username":
                                                      client["username"],
                                                });
                                              }),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  gradient: const LinearGradient(
                                                    colors: [
                                                      Colors.black,
                                                      Color(0xff4D4855)
                                                    ],
                                                    begin: Alignment.bottomLeft,
                                                    end: Alignment.topRight,
                                                  ),
                                                  color: const Color(0xffFF4655),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    20,
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        Container(
                                                          height: Get.height *
                                                              0.275,
                                                          width: Get.width,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child: ClipRRect(
                                                              borderRadius: const BorderRadius
                                                                      .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20)),
                                                              child:
                                                                  Image.network(
                                                                client["image"],
                                                                fit: BoxFit
                                                                    .cover,
                                                              )),
                                                        ),
                                                        Positioned(
                                                          top: Get.height *
                                                              0.025,
                                                          right:
                                                              Get.width * 0.076,
                                                          child: Container(
                                                            height: 60,
                                                            width: 60,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: const Color(
                                                                      0xff65696E)
                                                                  .withOpacity(
                                                                      0.4),
                                                            ),
                                                            child: Center(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    DateFormat(
                                                                            "d")
                                                                        .format(
                                                                      DateTime
                                                                          .parse(
                                                                        client[
                                                                            "start_time"],
                                                                      ),
                                                                    ),
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                  Text(
                                                                    DateFormat(
                                                                            "MMMM")
                                                                        .format(
                                                                      DateTime
                                                                          .parse(
                                                                        client[
                                                                            "start_time"],
                                                                      ),
                                                                    ),
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize:
                                                                            10),
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
                                                          vertical: 20,
                                                          horizontal: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            width: Get.width *
                                                                0.65,
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      client[
                                                                          "name"],
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      client[
                                                                          "location"],
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                    Text(
                                                                      " - ${DateFormat("hh:mm a").format(
                                                                        DateTime
                                                                            .parse(
                                                                          client[
                                                                              "start_time"],
                                                                        ),
                                                                      )}",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: Colors
                                                                    .white),
                                                            child: Text(
                                                              "₹ ${client["price"]}",
                                                              style: const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: Get.height * 0.03,
                                              )
                                            ],
                                          ),
                                        )
                                      : InkWell(
                                          child: Container(),
                                        ));

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
    ));
  }
}
