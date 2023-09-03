import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Views/User/Profile/random_user_profile.dart';
import 'package:eventflow/Views/User/Profile/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Misc/Firebase/firebase_tables.dart';
import 'package:get/get.dart';

class SearchFriendsScreen extends StatefulWidget {
  const SearchFriendsScreen({super.key});

  @override
  State<SearchFriendsScreen> createState() => _SearchFriendsScreenState();
}

class _SearchFriendsScreenState extends State<SearchFriendsScreen> {
  String title = "";
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        color: const Color(0xff0A171F),
        child: Container(
          height: Get.height,
          margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      title = value.toString();
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                  controller: searchController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: const Color(0xff352D3C),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1, //<-- SEE HERE
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelStyle: const TextStyle(color: Colors.grey),
                    alignLabelWithHint: true,
                    contentPadding: const EdgeInsets.only(
                      top: 2,
                      left: 5,
                    ),
                    errorStyle: const TextStyle(fontSize: 0),
                    hintStyle: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w400),
                    hintText: "Search",
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: Get.height * 0.8,
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
                                final clientWidget = title.isEmpty
                                    ? Container()
                                    : client["username"]
                                            .toString()
                                            .toLowerCase()
                                            .contains(title.toLowerCase())
                                        ? Container(
                                            child: InkWell(onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder:(context){
                                                return RandomUserProfileScreen({"email":client["email"],
                                                  "phone_number":client["phone_number"],
                                                  "name":client["name"],
                                                  "id":client["id"],
                                                  "follower":client["follower"],
                                                  "following":client["following"],
                                                  "image":client["image"]
                                                });
                                              }),);
                                            },
                                              child: Card(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 20),
                                                  color:
                                                      const Color(0xff0A171F),
                                                  child: ListTile(
                                                    leading: CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
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
    ));
  }
}
