import 'package:eventflow/Models/Event.dart';
import 'package:eventflow/Reusable_Components/User/event_card.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DisplayEventsScreen extends StatelessWidget {
  final List<Event> events = [
    Event(
        companyName: "Event planner and co",
        companyLogo: "assets/images/main-logos.png",
        eventImage: "assets/images/timepass.jpg",
        eventTime: "14-16",
        eventName: "Mountain Climbing",
        eventLocation: "Dongri, Mumbai"),
    Event(
        companyName: "Google",
        companyLogo: "assets/images/google-logo.png",
        eventImage: "assets/images/timepass2.jpg",
        eventTime: "12-2",
        eventName: "Night Party",
        eventLocation: "Thane, Mumbai"),
    Event(
        companyName: "Facebook",
        companyLogo: "assets/images/facebook-logo.png",
        eventImage: "assets/images/timepass3.jpg",
        eventTime: "16-22",
        eventName: "Concert",
        eventLocation: "Gandhinagar, Gujarat"),
    Event(
        companyName: "Microsoft",
        companyLogo: "assets/images/microsoft-logo.png",
        eventImage: "assets/images/timepass4.jpg",
        eventTime: "8-12",
        eventName: "Marathon",
        eventLocation: "Trivandum, Kerala"),
  ];

  DisplayEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding:
            EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Upcoming Events",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Expanded(
              child: ListView.builder(itemCount: events.length,
                itemBuilder: (context, index) {
                  return EventCard(events[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
