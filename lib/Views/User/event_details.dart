import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class EventDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> eventData;

  const EventDetailsScreen(this.eventData, {super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: Get.height * 0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  widget.eventData["image"],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
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
                          widget.eventData["name"],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: Get.width * 0.2,height: Get.height*0.04,
                          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
                          alignment: Alignment.center,
                          child: Text("₹${widget.eventData["price"]}",style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
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
                          DateFormat('yMMMMEEEEd').format(
                            DateTime.parse(
                              widget.eventData["start_time"],
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
                              widget.eventData["start_time"],
                            ),
                          )}-${DateFormat("hh:mm a").format(
                            DateTime.parse(
                              widget.eventData["end_time"],
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
                          widget.eventData["location"],
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
                    SizedBox(height: 80,

                      child: SingleChildScrollView(
                        child: Text(
                          widget.eventData["description"],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    CircularPercentIndicator(
                      radius: 120.0,
                      lineWidth: 10.0,
                      animation: true,
                      percent:double.parse((10/widget.eventData["max_participants"]).toString()) ,
                      center: Text(
                       "${widget.eventData["max_participants"]} spots left",
                        style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      backgroundColor: Colors.grey,
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.redAccent,
                    ),
                    SizedBox(height: 20,),
                    ElevatedButton(onPressed: (){}, child: Text("Book a spot")),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
