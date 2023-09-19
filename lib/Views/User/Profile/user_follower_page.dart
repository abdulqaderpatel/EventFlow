import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


import '../../Misc/Firebase/firebase_tables.dart';



class UserFollowerScreen extends StatefulWidget {
  const UserFollowerScreen({super.key});

  @override
  State<UserFollowerScreen> createState() => _UserFollowerScreenState();
}

class _UserFollowerScreenState extends State<UserFollowerScreen> {


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(value: const SystemUiOverlayStyle(statusBarColor: Color(0xff00141C)),
      child: Scaffold(
        appBar: AppBar(

          backgroundColor: const Color(0xff00141C),
          title: const Text("Followers"),
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
                                .where("id",
                                isNotEqualTo:
                                FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              List<Container> clientWidgets = [];
                              if (snapshot.hasData) {
                                final clients = snapshot.data?.docs;
                                for (var client in clients!) {
                                  final clientWidget = client["following"].contains(FirebaseAuth.instance.currentUser!.uid)

                                      ? Container(
                                    child: Card(
                                        margin: const EdgeInsets.only(
                                            bottom: 20),
                                        color: const Color(0xff0A171F),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                client["image"]),
                                          ),
                                          title: Text(
                                            client["username"],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight:
                                                FontWeight.w600),
                                          ),
                                          subtitle: Text(
                                            client["name"],
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight:
                                                FontWeight.w500),
                                          ),
                                        )),
                                  )
                                      : Container();
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
