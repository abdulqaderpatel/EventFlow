import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Views/User/chat_screen.dart';
import 'package:eventflow/Views/User/notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badge;

import '../Misc/Firebase/firebase_tables.dart';

class SelectChatScreen extends StatefulWidget {
  const SelectChatScreen({super.key});

  @override
  State<SelectChatScreen> createState() => _SelectChatScreenState();
}

class _SelectChatScreenState extends State<SelectChatScreen> {
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
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Color(0xff00141C),
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Container(),
            Center(child: Text("Message")),
            InkWell(onTap: (){
              FirebaseTable().usersTable.doc(FirebaseAuth.instance.currentUser!.uid).update({"notification":[]});
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return NotificationsScreen();
              }));
            },child:Container(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseTable()
                      .usersTable
                      .where("email",
                      isEqualTo:
                      FirebaseAuth.instance.currentUser!.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<badge.Badge> clientWidgets = [];
                    if (snapshot.hasData) {
                      final clients = snapshot.data?.docs;
                      for (var client in clients!) {
                        final clientWidget =client["notification"].length==0?badge.Badge(child: (Icon(Icons.menu)),):badge.Badge(badgeContent: Text(client["notification"].length.toString()),child: Icon(Icons.menu),);


                        clientWidgets.add(clientWidget);
                      }
                    }
                    return Column(
                      children: clientWidgets,
                    );
                  }),
            ))
          ],
        ),
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
                              .where("email",
                                  isNotEqualTo:
                                      FirebaseAuth.instance.currentUser!.email)
                              .snapshots(),
                          builder: (context, snapshot) {
                            List<Container> clientWidgets = [];
                            if (snapshot.hasData) {
                              final clients = snapshot.data?.docs;
                              for (var client in clients!) {
                                final clientWidget = ((client["follower"])
                                            .contains(FirebaseAuth
                                                .instance.currentUser!.uid
                                                .toString()) &&
                                        (client["following"]).contains(
                                            FirebaseAuth
                                                .instance.currentUser!.uid))
                                    ? Container(
                                        child: InkWell(
                                          onTap: () {
                                            List<String> ids = [
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              client["id"]
                                            ];
                                            ids.sort();

                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ChatScreen(ids.join("_"), {
                                                "email": client["email"],
                                                "phone_number":
                                                    client["phone_number"],
                                                "name": client["name"],
                                                "id": client["id"],
                                                "follower": client["follower"],
                                                "following":
                                                    client["following"],
                                                "image": client["image"]
                                              });
                                            }));
                                          },
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
                                        ),
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
    );
  }
}
