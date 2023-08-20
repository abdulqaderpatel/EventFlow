import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:eventflow/Views/Misc/toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class EventDetailsScreen extends StatefulWidget {
  final String id;

  const EventDetailsScreen(this.id, {super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late bool isBooked;
  List<Map<String, dynamic>> eventData = [];

  bool isLoaded = false;
  List<Map<String, dynamic>> items = [];



  void incrementCounter() async {
    List<Map<String, dynamic>> temp = [];
    var data = await FirebaseTable()
        .eventsTable
        .where("id", isEqualTo: widget.id)
        .get();

    for (var element in data.docs) {
      setState(() {
        temp.add(element.data());
      });
    }
    eventData = temp;
    print(eventData);

    var friendsData = await FirebaseTable()
        .usersTable
        .where("email", isNotEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    for (var element in friendsData.docs) {
      items.add(element.data());
    }


    setState(() {
      isLoaded = true;

      isBooked = eventData[0]["participants"]
          .contains(FirebaseAuth.instance.currentUser!.email);
    });
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    incrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoaded
            ? ListView(
                children: [
                  Container(
                    height: Get.height * 0.4,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          eventData[0]["image"],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xff1C2124),
                    ),
                    child: Container(
                      width: Get.width,
                      margin: EdgeInsets.only(
                        left: Get.width * 0.03,
                        right: Get.width * 0.03,
                        top: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                eventData[0]["name"],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                width: Get.width * 0.2,
                                height: Get.height * 0.04,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                alignment: Alignment.center,
                                child: Text(
                                  "₹${eventData[0]["price"]}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                color: Colors.yellow,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                DateFormat('yMMMMd').format(
                                  DateTime.parse(
                                    eventData[0]["start_time"],
                                  ),
                                ),
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xffD2D4D4),
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(
                                Icons.watch_later,
                                color: Colors.yellow,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "${DateFormat('hh:mm').format(
                                  DateTime.parse(
                                    eventData[0]["start_time"],
                                  ),
                                )}-${DateFormat("hh:mm a").format(
                                  DateTime.parse(
                                    eventData[0]["end_time"],
                                  ),
                                )}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xffD2D4D4),
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Row(
                            children: [
                              Text(
                                "Event location",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.yellow,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                eventData[0]["location"],
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xffD2D4D4),
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          const Row(
                            children: [
                              Text(
                                "About this event",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 80,
                            child: SingleChildScrollView(
                              child: Text(
                                eventData[0]["description"],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                              "Participant limit: ${eventData[0]["max_participants"]}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(
                            height: 15,
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseTable()
                                  .eventsTable
                                  .where("id", isEqualTo: widget.id)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                List<CircularPercentIndicator> clientWidgets =
                                    [];
                                if (snapshot.hasData) {
                                  final clients = snapshot.data?.docs;
                                  for (var client in clients!) {
                                    final clientWidget =
                                        CircularPercentIndicator(
                                      radius: 120.0,
                                      lineWidth: 10.0,
                                      animation: true,
                                      percent: double.parse(
                                          (client["participants"].length /
                                                  client["max_participants"])
                                              .toString()),
                                      center: Text(
                                        "${client["max_participants"] - client["participants"].length} spots left",
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                      backgroundColor: Colors.grey,
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: Colors.redAccent,
                                    );
                                    clientWidgets.add(clientWidget);
                                  }
                                }
                                return Column(
                                  children: clientWidgets,
                                );
                              }),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await FirebaseTable()
                                  .eventsTable
                                  .doc(eventData[0]["id"])
                                  .update(
                                {
                                  "participants": FieldValue.arrayUnion(
                                    [
                                      FirebaseAuth.instance.currentUser!.email,
                                    ],
                                  ),
                                },
                              );
                              incrementCounter();

                              Toast().successMessage("Booked slot");
                            },
                            child: Text(isBooked ? "Booked" : "Book a spot"),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: EdgeInsets.all(10),
                                      height: 400,
                                      child: ListView.builder(
                                          itemCount:items.length,
                                          itemBuilder: (context, index) {
                                            if ((items[index]["follower"])
                                                .contains(FirebaseAuth.instance.currentUser!.email.toString()) &&
                                                (items[index]["following"])
                                                    .contains(FirebaseAuth.instance.currentUser!.email)) {
                                              return InkWell(
                                              onTap: () async {
                                                List<String> ids = [
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                 items[index]["id"]
                                                ];
                                                ids.sort();
                                                String time = DateTime.now()
                                                    .millisecondsSinceEpoch
                                                    .toString();
                                                await FirebaseTable()
                                                    .chatTable
                                                    .doc(ids.join("_"))
                                                    .collection("messages")
                                                    .doc(time)
                                                    .set({
                                                  "sender": FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .email,
                                                  "reciever":items[index]
                                                      ["email"],
                                                  "isText": false,
                                                  "name": eventData[0]
                                                      ["name"],
                                                  "price": eventData[0]
                                                      ["price"],
                                                  "start_time": eventData[0]
                                                      ["start_time"],
                                                  "location": eventData[0]
                                                      ["location"],
                                                  "image": eventData[0]
                                                      ["image"],
                                                  "id": eventData[0]["id"],
                                                });
                                                Toast().successMessage(
                                                    "Event shared successfully");
                                                Navigator.pop(context);
                                              },
                                              child: Card(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 20),
                                                  color:
                                                      const Color(0xff0A171F),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      side: const BorderSide(
                                                        width: 2,
                                                        color:
                                                            Color(0xff0A171F),
                                                      )),
                                                  child: ListTile(
                                                    leading: CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                             items[index]
                                                                  ["image"]),
                                                    ),
                                                    title: Text(
                                                     items[index]["name"],
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    subtitle: Text(
                                                     items[index]["name"],
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  )),
                                            );
                                            }
                                            else{
                                              return Container();
                                            }
                                          }),
                                    );
                                  },
                                );
                              },
                              child: const Text("share"))
                        ],
                      ),
                    ),
                  )
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
