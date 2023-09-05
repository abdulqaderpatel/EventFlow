import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:eventflow/Views/User/event_details.dart';
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
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back),
            ),
            SizedBox(
              width: 300,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(widget.oppUser["image"]),
                ),
                title: Text(
                  widget.oppUser["name"],
                  maxLines: 1,
                  style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white,
                      fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        constraints: BoxConstraints(minWidth: Get.width),
        height: Get.height,
        color: const Color(0xff0F1A20),
        child: Stack(
          children: [
            Positioned(
              child: SingleChildScrollView(
                child: Container(
                  height: Get.height * 0.8,
                  padding: const EdgeInsets.only(bottom: 20),
                  margin: EdgeInsets.only(
                      top: 20, left: Get.width * 0.05, right: Get.width * 0.05),
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
                                            InkWell(
                                              onTap: () => Get.to(() =>
                                                  EventDetailsScreen({
                                                    "admin_image":
                                                        client["admin_image"],
                                                    "description":
                                                        client["description"],
                                                    "emails": client["emails"],
                                                    "end_time":
                                                        client["end_time"],
                                                    "event_creator":
                                                        client["event_creator"],
                                                    "id": client["id"],
                                                    "image": client["image"],
                                                    "location":
                                                        client["location"],
                                                    "max_participants": client[
                                                        "max_participants"],
                                                    "name": client["name"],
                                                    "participants":
                                                        client["participants"],
                                                    "price": client["price"],
                                                    "start_time":
                                                        client["start_time"],
                                                    "username":
                                                        client["username"],
                                                  })),
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 20),
                                                width: Get.width * 0.6,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: Get.height * 0.2,
                                                      width: Get.width,
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(
                                                                  client[
                                                                      "image"]))),
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      color: const Color(
                                                          0xff1C1C1C),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                client["name"],
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        20,
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
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              Text(
                                                                " - ${DateFormat("hh:mm a").format(
                                                                  DateTime
                                                                      .parse(
                                                                    client[
                                                                        "start_time"],
                                                                  ),
                                                                )}",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15,
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
                                              ),
                                            )
                                          ],
                                        ))
                                  : (client["isText"] == true
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                  color: Color(0xff3E4649),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomRight:
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
                                              MainAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () => Get.to(() =>
                                                  EventDetailsScreen({
                                                    "admin_image":
                                                        client["admin_image"],
                                                    "description":
                                                        client["description"],
                                                    "emails": client["emails"],
                                                    "end_time":
                                                        client["end_time"],
                                                    "event_creator":
                                                        client["event_creator"],
                                                    "id": client["id"],
                                                    "image": client["image"],
                                                    "location":
                                                        client["location"],
                                                    "max_participants": client[
                                                        "max_participants"],
                                                    "name": client["name"],
                                                    "participants":
                                                        client["participants"],
                                                    "price": client["price"],
                                                    "start_time":
                                                        client["start_time"],
                                                    "username":
                                                        client["username"],
                                                  })),
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 20),
                                                width: Get.width * 0.6,
                                                child: Column(
                                                  children: [
                                                    Image(
                                                      image: NetworkImage(
                                                        client["image"],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      color: const Color(
                                                          0xff1C1C1C),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                client["name"],
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        20,
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
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              Text(
                                                                " - ${DateFormat("hh:mm a").format(
                                                                  DateTime
                                                                      .parse(
                                                                    client[
                                                                        "start_time"],
                                                                  ),
                                                                )}",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        18,
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
