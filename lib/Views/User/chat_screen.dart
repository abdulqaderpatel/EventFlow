import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  String ids;
  Map<String, dynamic> oppUser;

  ChatScreen(this.ids, this.oppUser, {super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SizedBox(height: 20,),
          Container(
            height: Get.height * 0.85,
            margin: EdgeInsets.only(
                left: Get.width * 0.05, right: Get.width * 0.05),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseTable()
                    .chatTable
                    .doc(widget.ids)
                    .collection("messages")
                    .snapshots(),
                builder: (context, snapshot) {
                  List<Row> clientWidgets = [];
                  if (snapshot.hasData) {
                    final clients = snapshot.data?.docs;
                    for (var client in clients!) {
                      final clientWidget =client["sender"]==FirebaseAuth.instance.currentUser!.email? Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(margin: EdgeInsets.only(bottom: 20),
                            color: Colors.redAccent,
                            child: Text(
                              client["message"],
                            ),
                          ),
                        ],
                      ):Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(margin: EdgeInsets.only(bottom: 20),
                            color: Colors.blueAccent,
                            child: Text(
                              client["message"],
                            ),
                          ),
                        ],
                      );
                      clientWidgets.add(clientWidget);
                    }
                  }
                  return Column(
                    children: clientWidgets,
                  );
                }),
          ),
          Container(
            margin: EdgeInsets.only(
              left: Get.width * 0.05,
              right: Get.width * 0.05,
            ),
            child: Row(
              children: [
                SizedBox(
                    width: Get.width * 0.7,
                    child: TextField(
                      controller: messageController,
                    )),
                const SizedBox(
                  width: 19,
                ),
                InkWell(
                    onTap: () async {
                      String time =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      await FirebaseTable()
                          .chatTable
                          .doc(widget.ids)
                          .collection("messages")
                          .doc(time)
                          .set({
                        "sender": FirebaseAuth.instance.currentUser!.email,
                        "reciever": widget.oppUser["email"],
                        "time": time,
                        "message": messageController.text
                      });
                    },
                    child: const Icon(Icons.send)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
