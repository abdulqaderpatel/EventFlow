import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


import '../Misc/Firebase/firebase_tables.dart';

class ParticipantDetailsScreen extends StatefulWidget {
  final String id;

  const ParticipantDetailsScreen({required this.id, super.key});

  @override
  State<ParticipantDetailsScreen> createState() =>
      _ParticipantDetailsScreenState();
}

class _ParticipantDetailsScreenState extends State<ParticipantDetailsScreen> {
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> user = [];
  var isLoaded = false;
  List<bool> following = [];

  List<Map<String, dynamic>> chatItems = [];

  void getUsernameAndUserImage() async {
    List<Map<String, dynamic>> temp = [];
    var data = await FirebaseTable()
        .usersTable
        .where("email", isNotEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    for (var element in data.docs) {
      setState(() {
        temp.add(element.data());
      });
    }

    items = temp;

    temp = [];

    var userData = await FirebaseTable()
        .usersTable
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    for (var element in userData.docs) {
      temp.add(element.data());
    }

    user = temp;

    if (mounted) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUsernameAndUserImage();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Color(0xff00141C)),
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: const Color(0xff00141C), title: const Text("Participants")),
        body: Container(
          color: const Color(0xff0A171F),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
            child: Center(
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      Text(
                        "Email",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      Text(
                        "Age",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: Get.height * 0.78,
                    child: ListView(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseTable()
                                .eventsTable
                                .where("id", isEqualTo: widget.id)
                                .snapshots(),
                            builder: (context, snapshot) {
                              List<Column> clientWidgets = [];
                              if (snapshot.hasData) {
                                final clients = snapshot.data?.docs;
                                for (var client in clients!) {
                                  final clientWidget = Column(
                                    children:
                                    client["participants"].map<Widget>((e) {
                                  return client["emails"]
                                          .contains(e["email"])
                                      ? Container(
                                          margin: const EdgeInsets.only(top: 12),
                                          child: Row(

                                            children: [
                                              SizedBox(

                                                  width: Get.width * 0.33,
                                                  child: Text(
                                                    e["name"],maxLines: 1,
                                                    style: const TextStyle(overflow: TextOverflow.ellipsis,
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight
                                                                .w500),
                                                  )),
                                              SizedBox(width: Get.width*0.33,
                                                child: Text(
                                                  e["email"],textAlign: TextAlign.start,
                                                  style: const TextStyle(overflow: TextOverflow.ellipsis,
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              SizedBox(width:Get.width*0.24,
                                                child: Text(
                                                  e["age"],textAlign: TextAlign.end,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                          children: [
                                            SizedBox(width: Get.width*0.33,
                                              child: Text(
                                                e["name"],
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            SizedBox(width: Get.width*0.33,
                                              child: Text(
                                                e["email"],
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            SizedBox(width:Get.width*0.24,
                                              child: Text(
                                                e["age"],textAlign: TextAlign.end,
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        );
                                    }).toList(),
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
      ),
    );
  }
}
