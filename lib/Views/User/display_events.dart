import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:eventflow/Views/Misc/firebase_messaging.dart';
import 'package:eventflow/Views/User/event_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

class DisplayEventsScreen extends StatefulWidget {
  const DisplayEventsScreen({super.key});

  @override
  State<DisplayEventsScreen> createState() => _DisplayEventsScreenState();
}

class _DisplayEventsScreenState extends State<DisplayEventsScreen> {



  @override
  void initState() {


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
                  color: const Color(0xff404354),
                  padding: EdgeInsets.only(
                      left: Get.width * 0.05, right: Get.width * 0.05),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Your Events",
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      Container(height: Get.height*0.8,
                        child: ListView(
                          children: [
                                StreamBuilder<QuerySnapshot>(

                                stream: FirebaseTable()
                                    .eventsTable

                                    .snapshots(),
                                builder: (context, snapshot) {
                                  List<InkWell> clientWidgets = [];
                                  if (snapshot.hasData) {
                                    final clients = snapshot.data?.docs;
                                    for (var client in clients!) {
                                      final clientWidget=InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) {
                                              return EventDetailsScreen({
                                                "admin_image":client["admin_image"],
                                                "description":client["description"],
                                                "emails":client["emails"],
                                                "end_time":client["end_time"],
                                                "event_creator":client["event_creator"],
                                                "id":client["id"],
                                                "image":client["image"],
                                                "location":client["location"],
                                                "max_participants":client["max_participants"],
                                                "name":client["name"],
                                                "participants":client["participants"],
                                                "price":client["price"],
                                                "start_time":client["start_time"],
                                                "username":client["username"],
                                              });
                                            }),
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.circular(
                                                  20,
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        height: Get.height * 0.275,
                                                        width: Get.width,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                20)),
                                                        child: ClipRRect(
                                                            borderRadius:
                                                            const BorderRadius.only(
                                                                topRight:
                                                                Radius.circular(
                                                                    20),
                                                                topLeft:
                                                                Radius.circular(
                                                                    20)),
                                                            child: Image.network(
                                                              client["image"],
                                                              fit: BoxFit.cover,
                                                            )),
                                                      ),
                                                      Positioned(top: Get.height*0.025,right: Get.width*0.076,
                                                        child: Container(height:60,width: 60,decoration: BoxDecoration(shape: BoxShape.circle,color: const Color(0xff65696E).withOpacity(0.4),),
                                                          child: Center(
                                                            child: Column(mainAxisAlignment:MainAxisAlignment.center,
                                                              children: [
                                                                Text(DateFormat("d").format(
                                                                  DateTime.parse(
                                                                    client
                                                                    ["start_time"],
                                                                  ),
                                                                ),style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                                                Text(DateFormat("MMMM").format(
                                                                  DateTime.parse(
                                                                    client
                                                                    ["start_time"],
                                                                  ),
                                                                ),maxLines: 1,overflow: TextOverflow.ellipsis,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 10),),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                        vertical: 20, horizontal: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          width: Get.width * 0.65,
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    client["name"],
                                                                    style: const TextStyle(
                                                                        color:
                                                                        Colors.white,
                                                                        fontSize: 20,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    client
                                                                    ["location"],
                                                                    style: const TextStyle(
                                                                        color:
                                                                        Colors.white,
                                                                        fontSize: 18,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ),
                                                                  Text(
                                                                    " - ${DateFormat("hh:mm a").format(
                                                                      DateTime.parse(
                                                                        client
                                                                        ["start_time"],
                                                                      ),
                                                                    )}",
                                                                    style: const TextStyle(
                                                                        color:
                                                                        Colors.white,
                                                                        fontSize: 18,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                          const EdgeInsets.all(8),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  20),
                                                              color: Colors.white),
                                                          child: Text(
                                                            "₹ ${client["price"]}",
                                                            style: const TextStyle(
                                                                fontSize: 20,
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
                                              height: Get.height * 0.03,
                                            )
                                          ],
                                        ),
                                      );;
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
        )
           );
  }
}
