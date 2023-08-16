import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back),
            ),
            SizedBox(
              width: 200,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(widget.oppUser["image"]),
                ),
                title: Text(
                  widget.oppUser["name"],
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: Get.height,
        color: const Color(0xff0F1A20),
        child: Stack(
          children: [
            Positioned(
              child: SingleChildScrollView(
                child: Container(
                  height: Get.height * 0.8,padding: EdgeInsets.only(bottom: 20),
                  margin: EdgeInsets.only(top: 20,
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
                                  ? (client["isText"] == true
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                  color: Colors.redAccent,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                  )),
                                              padding: const EdgeInsets.all(10),
                                              constraints: BoxConstraints(
                                                  minWidth: 50,
                                                  maxWidth: Get.width * 0.75,
                                                  minHeight: 45),
                                              margin: const EdgeInsets.only(
                                                  bottom: 20),
                                              child: Text(
                                                client["message"],
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(margin: EdgeInsets.only(bottom: 20),
                                              width: Get.width * 0.6,
                                              child: Column(
                                                children: [
                                                  Image(
                                                    image: NetworkImage(
                                                      client["image"],
                                                    ),
                                                  ),
                                                  Container(padding: EdgeInsets.all(10),
                                                    color: Color(0xff1C1C1C),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              client["name"],
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
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
                                                              client[
                                                                  "location"],
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            Text(
                                                              " - ${DateFormat("hh:mm a").format(
                                                                DateTime.parse(
                                                                  client[
                                                                      "start_time"],
                                                                ),
                                                              )}",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ))
                                  :(client["isText"]==true? Row(
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
                                    ):Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  Container(margin: EdgeInsets.only(bottom: 20),
                                    width: Get.width * 0.6,
                                    child: Column(
                                      children: [
                                        Image(
                                          image: NetworkImage(
                                            client["image"],
                                          ),
                                        ),
                                        Container(padding: EdgeInsets.all(10),
                                          color: Color(0xff1C1C1C),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    client["name"],
                                                    style: const TextStyle(
                                                        color: Colors
                                                            .white,
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
                                                    client[
                                                    "location"],
                                                    style: const TextStyle(
                                                        color: Colors
                                                            .white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500),
                                                  ),
                                                  Text(
                                                    " - ${DateFormat("hh:mm a").format(
                                                      DateTime.parse(
                                                        client[
                                                        "start_time"],
                                                      ),
                                                    )}",
                                                    style: const TextStyle(
                                                        color: Colors
                                                            .white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ));
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
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 100,
                margin: EdgeInsets.only(
                  left: Get.width * 0.05,
                  right: Get.width * 0.05,
                ),
                child: Row(
                  children: [
                    SizedBox(
                        width: Get.width * 0.75,
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
                          if (messageController.text != "") {
                            FocusManager.instance.primaryFocus?.unfocus();
                            String message = messageController.text;
                            messageController.clear();
                            String time = DateTime.now()
                                .millisecondsSinceEpoch
                                .toString();
                            await FirebaseTable()
                                .chatTable
                                .doc(widget.ids)
                                .collection("messages")
                                .doc(time)
                                .set({
                              "sender":
                                  FirebaseAuth.instance.currentUser!.email,
                              "reciever": widget.oppUser["email"],
                              "time": time,
                              "message": message,
                              "isText": true,
                            });

                            scrollController.jumpTo(
                                scrollController.position.maxScrollExtent);
                          }
                        },
                        child: const Icon(
                          Icons.send,
                          size: 32,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
