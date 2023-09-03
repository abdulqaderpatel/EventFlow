import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:eventflow/Views/Misc/reciept/payment_reciept.dart';
import 'package:eventflow/Views/Misc/toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:http/http.dart' as http;

class EventDetailsScreen extends StatefulWidget {
  final String id;

  const EventDetailsScreen(this.id, {super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late bool isBooked;
  int participants = 0;
  List<Map<String, dynamic>> bookedUserData = [];
  List<Map<String, dynamic>> eventData = [];
  List<Map<String, dynamic>> userData = [];
  bool isLoaded = false;
  List<Map<String, dynamic>> items = [];
  List<TextEditingController> emailController = [];
  List<TextEditingController> nameController = [];
  List<TextEditingController> ageController = [];

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

    temp = [];
    var data2 = await FirebaseTable()
        .usersTable
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    for (var element in data2.docs) {
      setState(() {
        temp.add(element.data());
      });
    }
    userData = temp;

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

  Map<String, dynamic>? paymentIntent;

  void makePayment() async {
    try {
      paymentIntent = await createPaymentIntent();

      var gpay = const PaymentSheetGooglePay(
          merchantCountryCode: "IND", currencyCode: "IND", testEnv: true);
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            billingDetails: const BillingDetails(
                address: Address(
                    country: "IN",
                    city: "",
                    line1: "",
                    line2: "",
                    postalCode: "",
                    state: "")),
            paymentIntentClientSecret: paymentIntent!["client_secret"],
            style: ThemeMode.dark,
            merchantDisplayName: eventData[0]["event_creator"],
            googlePay: gpay),
      );

      displayPaymentSheet();
    } catch (e) {
      Toast().errorMessage(e.toString());
    }
  }

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await FirebaseTable().eventsTable.doc(eventData[0]["id"]).update(
        {
          "emails": FieldValue.arrayUnion(
            [
              FirebaseAuth.instance.currentUser!.email,
            ],
          ),
        },
      );
      incrementCounter();

      Toast().successMessage("Booked slot");
      Get.to(PaymentReciept(
        eventData: eventData,
        userData: userData,
        bookedUserData: bookedUserData,
      ));
      bookedUserData = [];
    } catch (e) {}
  }

  createPaymentIntent() async {
    try {
      Map<String, dynamic> body = {
        "amount": (eventData[0]["price"] * participants * 100).toString(),
        "currency": "inr"
      };
      http.Response response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization":
                "Bearer sk_test_51NjJbkSDqOoAu1Yvou3QlHodXEQKoN5nrvK6WP8t2kAdyzKAE2Jmd6umSMZuvh6WjhUvyO8VZpbJo1zFJSyaMvpP00rKeK3kPR",
            "Content-Type": "application/x-www-form-urlencoded"
          });
      return json.decode(response.body);
    } catch (e) {
      Toast().errorMessage("Sorry something went wrong");
    }
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    incrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    print("Change");
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
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(builder:
                                      (BuildContext context, modalState) {
                                    return Container(
                                      padding: const EdgeInsets.all(10),
                                      height: 300,
                                      color: const Color(0xff2C384C),
                                      child: Center(
                                        child: Column(
                                          children: <Widget>[
                                            const SizedBox(height: 15),
                                            const Text(
                                              'Enter no of participants',
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              height: 40,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      modalState(() {
                                                        participants++;
                                                      });
                                                    },
                                                    child: const Icon(
                                                      Icons.add,
                                                      size: 32,
                                                      color: Colors.white,
                                                    )),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  participants.toString(),
                                                  style: const TextStyle(
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    if (participants != 0) {
                                                      modalState(() {
                                                        participants--;
                                                      });
                                                    }
                                                  },
                                                  child: const Icon(
                                                    Icons.remove,
                                                    size: 32,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 15),
                                            ElevatedButton(
                                                child:
                                                    const Text('Enter Details'),
                                                onPressed: () {
                                                  for (int i = 0;
                                                      i < participants;
                                                      i++) {
                                                    nameController.add(
                                                        TextEditingController());
                                                    emailController.add(
                                                        TextEditingController());
                                                    ageController.add(
                                                        TextEditingController());
                                                  }
                                                  Navigator.pop(context);
                                                  showModalBottomSheet<void>(
                                                    isScrollControlled: true,
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return StatefulBuilder(
                                                          builder: (BuildContext
                                                                  context,
                                                              modalState) {
                                                        return ListView(
                                                          children: [
                                                            SizedBox(
                                                                height: 100),
                                                            Container(
                                                              height:
                                                                  Get.height,
                                                              color: const Color(
                                                                  0xff2C384C),
                                                              child: Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          10),
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal: Get.width *
                                                                              0.05),
                                                                  height: Get
                                                                      .height,
                                                                  child: Center(
                                                                      child:
                                                                          Column(
                                                                    children: [
                                                                      const Text(
                                                                        "Enter Participant Details",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                24,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      Container(
                                                                        height: Get.height *
                                                                            0.75,
                                                                        child: ListView
                                                                            .builder(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 15),
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemCount:
                                                                              participants,
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            nameController[0].text =
                                                                                userData[0]["name"];
                                                                            emailController[0].text =
                                                                                userData[0]["email"];
                                                                            return Padding(
                                                                              padding: const EdgeInsets.only(top: 15),
                                                                              child: Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Container(
                                                                                      alignment: Alignment.center,
                                                                                      decoration: BoxDecoration(
                                                                                        color: const Color(0xFF2E384E),
                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                      ),
                                                                                      child: Column(
                                                                                        children: [
                                                                                          Text(
                                                                                            "Person ${index + 1}",
                                                                                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                                                                                          ),
                                                                                          TextField(
                                                                                            controller: nameController[index],
                                                                                            autofocus: false,
                                                                                            style: const TextStyle(color: Color(0xFFF8F8FF)),
                                                                                            decoration: const InputDecoration(
                                                                                              border: InputBorder.none,
                                                                                              hintText: "Enter name",
                                                                                              hintStyle: TextStyle(color: Color.fromARGB(255, 132, 140, 155)),
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(height: 10),
                                                                                          TextField(
                                                                                            controller: emailController[index],
                                                                                            autofocus: false,
                                                                                            style: const TextStyle(color: Color(0xFFF8F8FF)),
                                                                                            decoration: const InputDecoration(
                                                                                              border: InputBorder.none,
                                                                                              hintText: "Enter email",
                                                                                              hintStyle: TextStyle(color: Color.fromARGB(255, 132, 140, 155)),
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(height: 10),
                                                                                          TextField(
                                                                                            controller: ageController[index],
                                                                                            autofocus: false,
                                                                                            style: const TextStyle(color: Color(0xFFF8F8FF)),
                                                                                            decoration: const InputDecoration(
                                                                                              border: InputBorder.none,
                                                                                              hintText: "Enter age",
                                                                                              hintStyle: TextStyle(color: Color.fromARGB(255, 132, 140, 155)),
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(height: 10),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              15),
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () async {
                                                                            for (int i = 0;
                                                                                i < participants;
                                                                                i++) {
                                                                              Map<String, dynamic> userData = {
                                                                                "no": "${i + 1}",
                                                                                "name": nameController[i].text,
                                                                                "email": emailController[i].text,
                                                                                "age": ageController[i].text
                                                                              };
                                                                              bookedUserData.add(userData);
                                                                              await FirebaseTable().eventsTable.doc(widget.id).update({
                                                                                "participants": FieldValue.arrayUnion([
                                                                                  userData
                                                                                ])
                                                                              });
                                                                              userData = {};
                                                                            }

                                                                            makePayment();
                                                                          },
                                                                          child:
                                                                              const Text("Pay")),
                                                                    ],
                                                                  ))),
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                    },
                                                  );
                                                }),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                                },
                              );
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
                                      padding: const EdgeInsets.all(10),
                                      height: 400,
                                      child: ListView.builder(
                                          itemCount: items.length,
                                          itemBuilder: (context, index) {
                                            if ((items[index]["follower"])
                                                    .contains(FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .email
                                                        .toString()) &&
                                                (items[index]["following"])
                                                    .contains(FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .email)) {
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
                                                    "reciever": items[index]
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
                                                child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 20),
                                                    color:
                                                        const Color(0xff0A171F),
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
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      subtitle: Text(
                                                        items[index]["name"],
                                                        style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    )),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          }),
                                    );
                                  },
                                );
                              },
                              child: const Text("share")),
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
