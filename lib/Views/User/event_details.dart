import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:eventflow/Views/Misc/reciept/payment_reciept.dart';
import 'package:eventflow/Views/Misc/toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import "../Misc/notification_service.dart";

import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:http/http.dart' as http;

class EventDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const EventDetailsScreen(this.data, {super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  int participants = 0;
  double rate = 0;
  bool isLoading = false;
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

      await FirebaseTable()
          .usersTable
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Reciepts")
          .doc(widget.data["id"])
          .set({
        "id": widget.data["id"],
        "bill": DateTime.now().millisecondsSinceEpoch,
        "name": widget.data["name"],
        "image": widget.data["image"],
        "userdata": bookedUserData,
        "price": bookedUserData.length * widget.data["price"],
        "Date": DateFormat('yMMMMd').format(
          DateTime.parse(
            DateTime.now().toString(),
          ),
        ),
      });

     final serviceId='service_mvh1mfq';
     final templateId='template_1h0pxtb';
     final userid="D7BfmJv7IK0otiGd6";
     
     final url=Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
     final response=await http.post(url,headers: {
     'origin': 'http://localhost',
       'Content-Type':'application/json'
     },body:jsonEncode( {
       'service_id':serviceId,
       'template_id':templateId,
       'user_id':userid,
       "template_params":{
         "name":FirebaseAuth.instance.currentUser!.displayName,
         "to_email":FirebaseAuth.instance.currentUser!.email,
         "event":widget.data["name"]
       }
     }));
     print(response.body);

      Toast().successMessage("Booked slot");
      DateTime date = DateTime.parse(widget.data["start_time"]);
      var time = Timestamp.fromDate(date);
      int number = time.millisecondsSinceEpoch;

      NotificationService().showNotification(
          1, "Event starting soon", "we hope to see you there!", (1000));
      Get.to(PaymentReciept(
        eventData: widget.data,
        userData: userData,
        bookedUserData: bookedUserData,
      ));
      bookedUserData = [];
    } catch (e) {
      Toast().errorMessage("Something went Wrong, please try again");
    }
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
                                  color: Colors.red,
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
                                          fontSize: 14,
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
                                          fontSize: 14,
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
                                DateTime.now().isBefore(
                                        DateTime.parse(client["end_time"]))
                                    ? Text(
                                        "Participant limit: ${client["max_participants"]}",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500))
                                    : client["event_creator"] ==
                                            FirebaseAuth.instance.currentUser!
                                                .displayName
                                        ? Text(
                                            "Average Rating: ${client["rating"].map((m) => m).reduce((a, b) => a + b) / client["rating"].length} ",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500))
                                        : (!client["raters"].contains(
                                                FirebaseAuth.instance
                                                    .currentUser!.email)
                                            ? Text("Your rating: $rate",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500))
                                            : Container()),
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
                                    : !client["raters"].contains(FirebaseAuth
                                            .instance.currentUser!.email)
                                        ? RatingBar(
                                            initialRating: 0,
                                            minRating: 0,
                                            maxRating: 5,
                                            allowHalfRating: true,
                                            itemSize: 30.0,
                                            ratingWidget: RatingWidget(
                                              full: const Icon(Icons.star,
                                                  color: Colors.redAccent),
                                              half: const Icon(Icons.star_half,
                                                  color: Colors.redAccent),
                                              empty: const Icon(
                                                  Icons.star_border,
                                                  color: Colors.redAccent),
                                            ),
                                            onRatingUpdate: (rating) {
                                              setState(() {
                                                rate = rating;
                                              });
                                            },
                                          )
                                        : Container(),
                                const SizedBox(
                                  height: 20,
                                ),
                                DateTime.now().isAfter(
                                        DateTime.parse(client["end_time"]))
                                    ? (client["raters"].contains(FirebaseAuth
                                            .instance.currentUser!.email)
                                        ? ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                minimumSize:
                                                    Size(Get.width, 40),
                                                backgroundColor:
                                                    const Color(0xffB83B5D),
                                                textStyle: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight
                                                        .w500) // Background color
                                                ),
                                            onPressed: () {},
                                            child: const Text("Already Rated"))
                                        : ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                minimumSize:
                                                    Size(Get.width, 40),
                                                backgroundColor: Colors.red,
                                                textStyle: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight
                                                        .w500) // Background color
                                                ),
                                            onPressed: () {
                                              FirebaseTable()
                                                  .eventsTable
                                                  .doc(widget.data["id"])
                                                  .update({
                                                "rating":
                                                    FieldValue.increment(rate),
                                                "raters":
                                                    FieldValue.arrayUnion([
                                                  FirebaseAuth.instance
                                                      .currentUser!.email
                                                ])
                                              });
                                            },
                                            child: const Text("Rate")))
                                    : (client["emails"].contains(FirebaseAuth.instance.currentUser!.email)
                                        ? ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                minimumSize:
                                                    Size(Get.width, 40),
                                                backgroundColor: Colors.red,
                                                textStyle: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight
                                                        .w500) // Background color
                                                ),
                                            onPressed: () {},
                                            child: const Text("Booked"),
                                          )
                                        : ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                minimumSize:
                                                    Size(Get.width, 40),
                                                backgroundColor:
                                                    const Color(0xffB83B5D),
                                                textStyle: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight
                                                        .w500) // Background color
                                                ),
                                            onPressed: () async {
                                              showModalBottomSheet<void>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return StatefulBuilder(
                                                      builder:
                                                          (BuildContext context,
                                                              modalState) {
                                                    return Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      height: 300,
                                                      color: const Color(
                                                          0xff2C384C),
                                                      child: Center(
                                                        child: Column(
                                                          children: <Widget>[
                                                            const SizedBox(
                                                                height: 15),
                                                            const Text(
                                                              'Enter no of participants',
                                                              style: TextStyle(
                                                                  fontSize: 24,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            const SizedBox(
                                                              height: 40,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                InkWell(
                                                                    onTap: () {
                                                                      modalState(
                                                                          () {
                                                                        participants++;
                                                                      });
                                                                    },
                                                                    child:
                                                                        const Icon(
                                                                      Icons.add,
                                                                      size: 32,
                                                                      color: Colors
                                                                          .white,
                                                                    )),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  participants
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          32,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    if (participants !=
                                                                        0) {
                                                                      modalState(
                                                                          () {
                                                                        participants--;
                                                                      });
                                                                    }
                                                                  },
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .remove,
                                                                    size: 32,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 15),
                                                            ElevatedButton(
                                                                child: const Text(
                                                                    'Enter Details'),
                                                                onPressed: () {
                                                                  nameController
                                                                      .clear();
                                                                  emailController
                                                                      .clear();
                                                                  ageController
                                                                      .clear();
                                                                  participantPages
                                                                      .clear();
                                                                  for (int i =
                                                                          0;
                                                                      i < participants;
                                                                      i++) {
                                                                    nameController
                                                                        .add(
                                                                            TextEditingController());
                                                                    emailController
                                                                        .add(
                                                                            TextEditingController());
                                                                    ageController
                                                                        .add(
                                                                            TextEditingController());
                                                                    participantPages
                                                                        .add(i +
                                                                            1);
                                                                  }

                                                                  Navigator.pop(
                                                                      context);
                                                                  showModalBottomSheet<
                                                                      void>(
                                                                    isScrollControlled:
                                                                        true,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return SingleChildScrollView(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                          child:
                                                                              StatefulBuilder(builder: (BuildContext context, modalState) {
                                                                            return Container(
                                                                              padding: const EdgeInsets.only(top: 15),
                                                                              color: const Color(0xff201A30),
                                                                              child: Container(
                                                                                  padding: const EdgeInsets.all(10),
                                                                                  margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                                                                                  height: Get.height,
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      const Text(
                                                                                        "Enter Participant Details",
                                                                                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        height: 120,
                                                                                      ),
                                                                                      Container(
                                                                                        height: Get.height * 0.50,
                                                                                        child: ListView.builder(
                                                                                          scrollDirection: Axis.horizontal,
                                                                                          shrinkWrap: true,
                                                                                          itemCount: participants,
                                                                                          controller: scrollController,
                                                                                          itemBuilder: (context, index) {
                                                                                            nameController[0].text = FirebaseAuth.instance.currentUser!.displayName!;
                                                                                            emailController[0].text = FirebaseAuth.instance.currentUser!.email!;
                                                                                            return Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                              children: [
                                                                                                Container(
                                                                                                  width: 280,
                                                                                                  padding: const EdgeInsets.only(top: 15),
                                                                                                  child: Row(
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                        child: Container(
                                                                                                          margin: const EdgeInsets.only(right: 20),
                                                                                                          alignment: Alignment.center,
                                                                                                          decoration: BoxDecoration(
                                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                                          ),
                                                                                                          child: Column(
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                "Person ${index + 1}",
                                                                                                                textAlign: TextAlign.center,
                                                                                                                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
                                                                                                              ),
                                                                                                              const SizedBox(
                                                                                                                height: 10,
                                                                                                              ),
                                                                                                              SizedBox(
                                                                                                                width: 260,
                                                                                                                height: 80,
                                                                                                                child: TextField(
                                                                                                                  controller: nameController[index],
                                                                                                                  style: const TextStyle(color: Color(0xFFF8F8FF)),
                                                                                                                  decoration: InputDecoration(
                                                                                                                    filled: true,
                                                                                                                    fillColor: const Color(0xff38304C),
                                                                                                                    border: InputBorder.none,
                                                                                                                    labelText: "Name",
                                                                                                                    prefixIcon: const Icon(Icons.person),
                                                                                                                    hintText: "Enter name",
                                                                                                                    hintStyle: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w400),
                                                                                                                    focusedBorder: OutlineInputBorder(
                                                                                                                      borderRadius: BorderRadius.circular(15),
                                                                                                                    ),
                                                                                                                    enabledBorder: OutlineInputBorder(
                                                                                                                      borderRadius: BorderRadius.circular(15),
                                                                                                                      borderSide: const BorderSide(
                                                                                                                        width: 0,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                              const SizedBox(height: 10),
                                                                                                              SizedBox(
                                                                                                                width: 260,
                                                                                                                height: 80,
                                                                                                                child: TextField(
                                                                                                                  controller: emailController[index],
                                                                                                                  style: const TextStyle(color: Color(0xFFF8F8FF)),
                                                                                                                  decoration: InputDecoration(
                                                                                                                    filled: true,
                                                                                                                    fillColor: const Color(0xff38304C),
                                                                                                                    border: InputBorder.none,
                                                                                                                    labelText: "Email",
                                                                                                                    prefixIcon: const Icon(Icons.email),
                                                                                                                    hintText: "Enter email",
                                                                                                                    hintStyle: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w400),
                                                                                                                    focusedBorder: OutlineInputBorder(
                                                                                                                      borderRadius: BorderRadius.circular(15),
                                                                                                                    ),
                                                                                                                    enabledBorder: OutlineInputBorder(
                                                                                                                      borderRadius: BorderRadius.circular(15),
                                                                                                                      borderSide: const BorderSide(
                                                                                                                        width: 0,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                              const SizedBox(height: 10),
                                                                                                              SizedBox(
                                                                                                                width: 260,
                                                                                                                height: 80,
                                                                                                                child: TextField(
                                                                                                                  keyboardType: TextInputType.number,
                                                                                                                  controller: ageController[index],
                                                                                                                  style: const TextStyle(color: Color(0xFFF8F8FF)),
                                                                                                                  decoration: InputDecoration(
                                                                                                                    filled: true,
                                                                                                                    fillColor: const Color(0xff38304C),
                                                                                                                    border: InputBorder.none,
                                                                                                                    labelText: "Age",
                                                                                                                    prefixIcon: const Icon(Icons.text_increase),
                                                                                                                    hintText: "Enter Age",
                                                                                                                    hintStyle: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w400),
                                                                                                                    focusedBorder: OutlineInputBorder(
                                                                                                                      borderRadius: BorderRadius.circular(15),
                                                                                                                    ),
                                                                                                                    enabledBorder: OutlineInputBorder(
                                                                                                                      borderRadius: BorderRadius.circular(15),
                                                                                                                      borderSide: const BorderSide(
                                                                                                                        width: 0,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                                const SizedBox(
                                                                                                  width: 20,
                                                                                                )
                                                                                              ],
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      Row(
                                                                                          children: participantPages.map((e) {
                                                                                        return InkWell(
                                                                                          onTap: () {
                                                                                            scrollController.animateTo((e - 1) * 280.toDouble(), duration: const Duration(milliseconds: 500), curve: Curves.ease);
                                                                                          },
                                                                                          child: Row(
                                                                                            children: [
                                                                                              Container(
                                                                                                  color: const Color(0xff382E4C),
                                                                                                  height: 20,
                                                                                                  width: 20,
                                                                                                  child: Center(
                                                                                                      child: Text(
                                                                                                    e.toString(),
                                                                                                    style: const TextStyle(color: Colors.white),
                                                                                                  ))),
                                                                                              const SizedBox(width: 5),
                                                                                            ],
                                                                                          ),
                                                                                        );
                                                                                      }).toList()),
                                                                                      const SizedBox(height: 85),
                                                                                      ElevatedButton(
                                                                                          style: ElevatedButton.styleFrom(minimumSize: Size(Get.width, 40), backgroundColor: const Color(0xffB83B5D), textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500) // Background color
                                                                                              ),
                                                                                          onPressed: () async {
                                                                                            modalState(() {
                                                                                              isLoading = true;
                                                                                            });
                                                                                            bool validate = false;
                                                                                            for (int i = 0; i < nameController.length; i++) {
                                                                                              if (nameController[i].text.isEmpty) {
                                                                                                Toast().errorMessage("Name Cannot be empty");
                                                                                                modalState(() {
                                                                                                  isLoading = false;
                                                                                                });
                                                                                                validate = false;
                                                                                                break;
                                                                                              } else if (emailController[i].text.isEmpty) {
                                                                                                validate = false;
                                                                                                Toast().errorMessage("Email cannot be empty");
                                                                                                modalState(() {
                                                                                                  isLoading = false;
                                                                                                });
                                                                                                break;
                                                                                              } else if (ageController[i].text.isEmpty) {
                                                                                                validate = false;
                                                                                                Toast().errorMessage("Age cannot be empty");
                                                                                                modalState(() {
                                                                                                  isLoading = false;
                                                                                                });
                                                                                                break;
                                                                                              } else {
                                                                                                validate = true;
                                                                                              }
                                                                                            }
                                                                                            if (validate) {
                                                                                              for (int i = 0; i < participants; i++) {
                                                                                                Map<String, dynamic> userData = {
                                                                                                  "no": "${i + 1}",
                                                                                                  "name": nameController[i].text,
                                                                                                  "email": emailController[i].text,
                                                                                                  "age": ageController[i].text
                                                                                                };
                                                                                                bookedUserData.add(userData);

                                                                                                await FirebaseTable().eventsTable.doc(widget.data["id"]).update({
                                                                                                  "participants": FieldValue.arrayUnion([userData])
                                                                                                });
                                                                                              }
                                                                                              modalState(() {
                                                                                                isLoading = true;
                                                                                              });

                                                                                              Navigator.pop(context);
                                                                                              Navigator.pop(context);
                                                                                              makePayment();
                                                                                            }
                                                                                          },
                                                                                          child: isLoading ? CircularProgressIndicator() : const Text("Pay")),
                                                                                    ],
                                                                                  )),
                                                                            );
                                                                          }),
                                                                        ),
                                                                      );
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
                                            child: const Text("Book a spot"),
                                          )),
                                const SizedBox(
                                  height: 20,
                                ),
                                DateTime.now().isBefore(
                                        DateTime.parse(client["end_time"]))
                                    ? ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            minimumSize: Size(Get.width, 40),
                                            backgroundColor: Colors.blue,
                                            textStyle: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight
                                                    .w500) // Background color
                                            ),
                                        onPressed: () async {
                                          showModalBottomSheet<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                color: const Color(0xff0F1A20),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                height: 400,
                                                child: Column(
                                                  children: [
                                                    const Text(
                                                      "Share",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    StreamBuilder<
                                                            QuerySnapshot>(
                                                        stream: FirebaseTable()
                                                            .usersTable
                                                            .where("email",
                                                                isNotEqualTo:
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .email)
                                                            .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
                                                          List<Container>
                                                              clientWidgets =
                                                              [];
                                                          if (snapshot
                                                              .hasData) {
                                                            final clients =
                                                                snapshot
                                                                    .data?.docs;
                                                            for (var client
                                                                in clients!) {
                                                              final clientWidget = ((client["follower"]).contains(FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid
                                                                          .toString()) &&
                                                                      (client["following"]).contains(FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid))
                                                                  ? Container(
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          List<String>
                                                                              ids =
                                                                              [
                                                                            FirebaseAuth.instance.currentUser!.uid,
                                                                            client["id"]
                                                                          ];
                                                                          ids.sort();
                                                                          String
                                                                              time =
                                                                              DateTime.now().millisecondsSinceEpoch.toString();
                                                                          Map<String, dynamic>
                                                                              displayData =
                                                                              {
                                                                            "time":
                                                                                time,
                                                                            "sender":
                                                                                FirebaseAuth.instance.currentUser!.email,
                                                                            "reciever":
                                                                                client["email"],
                                                                            "isText":
                                                                                false,
                                                                          };
                                                                          Map<String, dynamic>
                                                                              completeData =
                                                                              {};
                                                                          completeData
                                                                              .addAll(widget.data);
                                                                          completeData
                                                                              .addAll(displayData);
                                                                          await FirebaseTable()
                                                                              .chatTable
                                                                              .doc(ids.join("_"))
                                                                              .collection("messages")
                                                                              .doc(time)
                                                                              .set(completeData);
                                                                          Toast()
                                                                              .successMessage("Event shared successfully");
                                                                          Navigator.pop(
                                                                              context);
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: Container(
                                                                            margin: const EdgeInsets.only(bottom: 20),
                                                                            color: const Color(0xff0A171F),
                                                                            child: ListTile(
                                                                              leading: CircleAvatar(
                                                                                backgroundImage: NetworkImage(client["image"]),
                                                                              ),
                                                                              title: Text(
                                                                                client["username"],
                                                                                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                                                                              ),
                                                                              subtitle: Text(
                                                                                client["name"],
                                                                                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            )),
                                                                      ),
                                                                    )
                                                                  : Container();
                                                              clientWidgets.add(
                                                                  clientWidget);
                                                            }
                                                          }
                                                          return Column(
                                                            children:
                                                                clientWidgets,
                                                          );
                                                        }),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: const Text("share"))
                                    : Container(),
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
