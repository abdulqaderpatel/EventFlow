import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  final String ids;
  final Map<String, dynamic> oppUser;

  const ChatScreen(this.ids, this.oppUser, {super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:Colors.grey,
      appBar: AppBar(automaticallyImplyLeading: false,title:Row(
        children: [
          InkWell(onTap: ()=>Navigator.pop(context),child:Icon(Icons.arrow_back) ,),
          SizedBox(
            width: 200,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.oppUser["image"]),
              ),
              title: Text(
                widget.oppUser["name"],
                style:
                const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          color: const Color(0xff0F1A20),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),

              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                child: Container(
                  height: Get.height * 0.75,
                  margin: EdgeInsets.only(
                      left: Get.width * 0.05, right: Get.width * 0.05),
                  child: SingleChildScrollView(
                    controller: scrollController,
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
                              final clientWidget = client["sender"] ==
                                      FirebaseAuth.instance.currentUser!.email
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.redAccent,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              )),
                                          padding: const EdgeInsets.all(10),
                                          constraints: BoxConstraints(
                                              minWidth: 50,
                                              maxWidth: Get.width * 0.75,
                                              minHeight: 45),
                                          margin:
                                              const EdgeInsets.only(bottom: 20),
                                          child: Text(
                                            client["message"],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                              color: Color(0xff3E4649),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10),
                                              )),
                                          padding: const EdgeInsets.all(10),
                                          constraints: BoxConstraints(
                                              minWidth: 50,
                                              maxWidth: Get.width * 0.75,
                                              minHeight: 45),
                                          margin:
                                              const EdgeInsets.only(bottom: 20),
                                          child: Text(
                                            client["message"],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400),
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
                ),
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
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              hintText: "Message",
                              hintStyle: TextStyle(color: Colors.grey)),
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
                          messageController.clear();
                          scrollController.jumpTo(
                              scrollController.position.maxScrollExtent);
                        },
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
