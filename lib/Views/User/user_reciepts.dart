import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';

import 'package:eventflow/Views/User/reciept_details.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';



class UserRecieptsScreen extends StatefulWidget {
  const UserRecieptsScreen({super.key});

  @override
  State<UserRecieptsScreen> createState() => _UserRecieptsScreenState();
}

class _UserRecieptsScreenState extends State<UserRecieptsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff00141C),
          title: const Text("Your Receipts"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: Get.height,
              color: const Color(0xff00141C),
              padding: EdgeInsets.only(
                  left: Get.width * 0.05, right: Get.width * 0.05),
              child: Column(
                children: [
                  Container(
                    height: Get.height * 0.87,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ListView(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseTable()
                                .usersTable
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection("Reciepts")
                                .snapshots(),
                            builder: (context, snapshot) {
                              List<Container> clientWidgets = [];
                              if (snapshot.hasData) {
                                final clients = snapshot.data?.docs;
                                for (var client in clients!) {
                                  final clientWidget = Container(
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(
                                            RecieptDetailsScreen(client["id"]));
                                      },
                                      child: Card(
                                          margin:
                                              const EdgeInsets.only(bottom: 20),
                                          color: const Color(0xff0A171F),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(client["image"]),
                                            ),
                                            title: Text(
                                              client["name"],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            subtitle: Text(
                                              "Price: ${client["price"]}",
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500),
                                            ),
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
        ));
  }
}
