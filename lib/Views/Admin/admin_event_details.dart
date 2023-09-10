import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Views/Admin/participant_details.dart';
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:eventflow/Views/Misc/reciept/payment_reciept.dart';
import 'package:eventflow/Views/Misc/toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import "package:timezone/data/latest.dart" as tz;
import "../Misc/notification_service.dart";

import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:http/http.dart' as http;

class AdminEventDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const AdminEventDetailsScreen(this.data, {super.key});

  @override
  State<AdminEventDetailsScreen> createState() =>
      _AdminEventDetailsScreenState();
}

class _AdminEventDetailsScreenState extends State<AdminEventDetailsScreen> {
  int participants = 0;
  List<Map<String, dynamic>> bookedUserData = [];
  List<Map<String, dynamic>> eventData = [];
  List<Map<String, dynamic>> userData = [];
  bool isLoaded = false;
  List<Map<String, dynamic>> items = [];
  List<TextEditingController> emailController = [];
  List<TextEditingController> nameController = [];
  List<TextEditingController> ageController = [];
  List<int> participantPages = [];
  late AutoScrollController controller;
  ScrollController scrollController = ScrollController();

  Future _scrollToIndex(int index) async {
    await controller.scrollToIndex(index,
        preferPosition: AutoScrollPosition.begin);
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
            merchantDisplayName: widget.data["event_creator"],
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
      await FirebaseTable().eventsTable.doc(widget.data["id"]).update(
        {
          "emails": FieldValue.arrayUnion(
            [
              FirebaseAuth.instance.currentUser!.email,
            ],
          ),
        },
      );

      Toast().successMessage("Booked slot");
      DateTime date = DateTime.parse(widget.data["start_time"]);
      var time = Timestamp.fromDate(date);
      int number = time.millisecondsSinceEpoch;

      NotificationService().showNotification(
          1, "Event starting soon", "we hope to see you there!", 10000);
      Get.to(PaymentReciept(
        eventData: widget.data,
        userData: userData,
        bookedUserData: bookedUserData,
      ));
      bookedUserData = [];
    } catch (e) {}
  }

  createPaymentIntent() async {
    try {
      Map<String, dynamic> body = {
        "amount": (widget.data["price"] * participants * 100).toString(),
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
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.horizontal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseTable()
                .eventsTable
                .where("id", isEqualTo: widget.data["id"])
                .snapshots(),
            builder: (context, snapshot) {
              List<Container> clientWidgets = [];
              if (snapshot.hasData) {
                final clients = snapshot.data?.docs;
                for (var client in clients!) {
                  final clientWidget = Container(
                    height: Get.height,
                    child: ListView(
                      children: [
                        Container(
                          height: Get.height * 0.4,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                client["image"],
                              ),
                            ),
                          ),
                          child: DateTime.now()
                                  .isBefore(DateTime.parse(client["end_time"]))
                              ? Container()
                              : const Banner(
                                  message: "Event Over",
                                  location: BannerLocation.topEnd,
                                  color: Colors.blue,
                                ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xff151924),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      client["name"],
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
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "₹${client["price"]}",
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
                                          client["start_time"],
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
                                          client["start_time"],
                                        ),
                                      )}-${DateFormat("hh:mm a").format(
                                        DateTime.parse(
                                          client["end_time"],
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
                                      client["location"],
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
                                      client["description"],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    DateTime.now().isBefore(
                                            DateTime.parse(client["end_time"]))
                                        ? "Participant limit: ${client["max_participants"]}"
                                        :client["raters"].length==0?"No ratings yet":"Average Rating: ${client["rating"] / client["raters"].length} from ${client["raters"].length} ${client["raters"].length == 1 ? "review" : "reviews"}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(
                                  height: 15,
                                ),
                                DateTime.now().isBefore(
                                        DateTime.parse(client["end_time"]))
                                    ? StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseTable()
                                            .eventsTable
                                            .where("id",
                                                isEqualTo: widget.data["id"])
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          List<CircularPercentIndicator>
                                              clientWidgets = [];
                                          if (snapshot.hasData) {
                                            final clients = snapshot.data?.docs;
                                            for (var client in clients!) {
                                              final clientWidget =
                                                  CircularPercentIndicator(
                                                radius: 120.0,
                                                lineWidth: 10.0,
                                                animation: true,
                                                percent: double.parse((client[
                                                                "participants"]
                                                            .length /
                                                        client[
                                                            "max_participants"])
                                                    .toString()),
                                                center: Text(
                                                  "${client["max_participants"] - client["participants"].length} spots left",
                                                  style: const TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                        })
                                    : IgnorePointer(
                                        child: RatingBar(
                                          initialRating:
                                              client["raters"].length == 0
                                                  ? 0
                                                  : client["rating"] /
                                                      client["raters"].length,
                                          minRating: 0,
                                          maxRating: 5,
                                          allowHalfRating: true,
                                          itemSize: 30.0,
                                          ratingWidget: RatingWidget(
                                            full: const Icon(Icons.star,
                                                color: Colors.blueAccent),
                                            half: const Icon(Icons.star_half,
                                                color: Colors.blueAccent),
                                            empty: const Icon(Icons.star_border,
                                                color: Colors.blueAccent),
                                          ),
                                          onRatingUpdate: (rating) {},
                                        ),
                                      ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size(Get.width, 40),
                                        primary: Color(0xffB83B5D),
                                        textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight
                                                .w500) // Background color
                                        ),
                                    onPressed: () async {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ParticipantDetailsScreen(
                                            id: widget.data["id"]);
                                      }));
                                    },
                                    child: const Text("Participant Details")),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                  clientWidgets.add(clientWidget);
                }
              }
              return Column(
                children: clientWidgets,
              );
            }));
  }
}
