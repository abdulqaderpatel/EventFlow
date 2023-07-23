import 'package:eventflow/Models/Event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EventCard extends StatelessWidget {
  final Event event;
  const EventCard(this.event, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
              
              side: const BorderSide(color: Color(0xffff6b74), width: 0),
              borderRadius: BorderRadius.circular(15)),
          elevation: 3,
          child: ListTile(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 2, color: Colors.red),
              borderRadius: BorderRadius.circular(15),
            ),
            tileColor: const Color(0xffff8a78),
            titleTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16),
            ),
            leading: CircleAvatar(
              backgroundImage: AssetImage(event.companyLogo),
            ),
            title: Text(event.companyName),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.red,
            ),
          ),
          elevation: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: Get.height * 0.45,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(
                  20,
                ),
                border: Border.all(color: Colors.red, width: 2)),
            child: Column(
              children: [
                Container(
                  height: Get.height * 0.225,
                  width: Get.width,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        event.eventImage,
                        fit: BoxFit.cover,
                      )),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Row(
                  children: [
                    Container(
                        height: Get.height * 0.03,
                        width: Get.width * 0.1,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black),
                        ),
                        child: Center(child: Text(event.eventTime))),
                    SizedBox(
                      width: Get.width * 0.6,
                      child: Center(
                        child: Text(
                          event.eventName,
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.green,
                      size: Get.width * 0.1,
                    ),
                    SizedBox(
                      width: Get.width * 0.6,
                      child: Center(
                        child: Text(
                          event.eventLocation,
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: Get.height * 0.03,
        )
      ],
    );
  }
}
