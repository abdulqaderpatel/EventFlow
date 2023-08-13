import 'package:eventflow/Views/User/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  List<Map<String, dynamic>> followingItems = [];
  List<Map<String, dynamic>> followerItems = [];
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

    var followingData = await FirebaseTable()
        .followingTable
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("userFollowing")
        .get();

    var followerData = await FirebaseTable()
        .followerTable
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("userFollower")
        .get();

    for (var element in followingData.docs) {
      followingItems.add(element.data());
    }

    for (var element in followerData.docs) {
      followerItems.add(element.data());
    }


    for (int i = 0; i < items.length; i++) {
      for (int j = 0; j < followingItems.length; j++) {
        if (items[i]["email"] == followingItems[j]["email"]) {
          for (int k = 0; k < followerItems.length; k++) {
            if (items[i]["email"] == followerItems[k]["email"]) {
              chatItems.add(items[i]);
            }
          }
        }
      }
    }

    print(chatItems);

    temp = [];

    var userData = await FirebaseTable()
        .usersTable
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    for (var element in userData.docs) {
      temp.add(element.data());
    }

    user = temp;

    if (this.mounted) {
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
        body: isLoaded
            ? Container(
                color: Colors.redAccent,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Select Chat",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                            child: ListView.builder(
                                itemCount: chatItems.length,
                                itemBuilder: (context, index) {
                                  return InkWell(onTap: (){
                                    List<String> ids=[FirebaseAuth.instance.currentUser!.uid,chatItems[index]["id"]];
                                    ids.sort();

                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      return ChatScreen(ids.join("_"),chatItems[index]);
                                    }));
                                  },
                                    child: Card(
                                        surfaceTintColor: Colors.greenAccent,
                                        shadowColor: Colors.blue,
                                        margin: EdgeInsets.only(bottom: 20),
                                        color: Colors.red,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: const BorderSide(
                                                width: 2, color: Colors.white)),
                                        elevation: 5,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                chatItems[index]["image"]),
                                          ),
                                          title: Text(
                                            chatItems[index]["username"],
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: Text(
                                            chatItems[index]["name"],
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )),
                                  );
                                }))
                      ],
                    ),
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()));
  }
}
