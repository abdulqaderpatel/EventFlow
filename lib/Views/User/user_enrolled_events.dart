import 'package:eventflow/Views/User/event_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

class UserEnrolledEventsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> userEvents;

  const UserEnrolledEventsScreen(this.userEvents, {super.key});

  @override
  State<UserEnrolledEventsScreen> createState() =>
      _UserEnrolledEventsScreenState();
}

class _UserEnrolledEventsScreenState extends State<UserEnrolledEventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: const Color(0xff404354),
      padding: EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Your Events",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ],
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.userEvents.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return EventDetailsScreen(
                            widget.userEvents[index]["id"]);
                      }),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: Get.height * 0.275,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          topLeft: Radius.circular(20)),
                                      child: Image.network(
                                        widget.userEvents[index]["image"],
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                Positioned(
                                  top: Get.height * 0.025,
                                  right: Get.width * 0.076,
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xff65696E)
                                          .withOpacity(0.4),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            DateFormat("d").format(
                                              DateTime.parse(
                                                widget.userEvents[index]
                                                    ["start_time"],
                                              ),
                                            ),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            DateFormat("MMMM").format(
                                              DateTime.parse(
                                                widget.userEvents[index]
                                                    ["start_time"],
                                              ),
                                            ),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: Get.width * 0.65,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              widget.userEvents[index]["name"],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              widget.userEvents[index]
                                                  ["location"],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              " - ${DateFormat("hh:mm a").format(
                                                DateTime.parse(
                                                  widget.userEvents[index]
                                                      ["end_time"],
                                                ),
                                              )}",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white),
                                    child: Text(
                                      "₹ ${widget.userEvents[index]["price"]}",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.03,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
