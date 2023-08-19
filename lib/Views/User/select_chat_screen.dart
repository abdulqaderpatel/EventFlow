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
        body: isLoaded
            ? Container(
                color: const Color(0xff0A171F),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                  child: Center(
                    child: Column(
                      children: [
                        Expanded(
                            child: ListView.builder(
                                itemCount: items.length,
                                itemBuilder: (context, index) {

                                  if ((items[index]["follower"])
                                      .contains(FirebaseAuth.instance.currentUser!.email.toString()) &&
                                      (items[index]["following"])
                                          .contains(FirebaseAuth.instance.currentUser!.email)) {


                                  return InkWell(
                                    onTap: () {
                                      List<String> ids = [
                                        FirebaseAuth.instance.currentUser!.uid,
                                        items[index]["id"]
                                      ];
                                      ids.sort();


                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ChatScreen(
                                            ids.join("_"), items[index]);
                                      }));
                                    },
                                    child: Card(
                                        margin:
                                            const EdgeInsets.only(bottom: 20),
                                        color: const Color(0xff0A171F),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: const BorderSide(
                                              width: 2,
                                              color: Color(0xff0A171F),
                                            )),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                items[index]["image"]),
                                          ),
                                          title: Text(
                                            items[index]["name"],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: Text(
                                            items[index]["name"],
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )),
                                  );}
                                  else{
                                    return Container();
                                  }
                                }))
                      ],
                    ),
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()));
  }
}
