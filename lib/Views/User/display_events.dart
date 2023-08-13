
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:eventflow/Views/User/event_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DisplayEventsScreen extends StatefulWidget {
  const DisplayEventsScreen({super.key});

  @override
  State<DisplayEventsScreen> createState() => _DisplayEventsScreenState();
}

class _DisplayEventsScreenState extends State<DisplayEventsScreen> {
  late List<Map<String, dynamic>> items;

  bool isLoaded = false;

  void incrementCounter() async {
    List<Map<String, dynamic>> temp = [];
    var data = await FirebaseTable().eventsTable.get();

    for (var element in data.docs) {
      setState(() {
        temp.add(element.data());
      });
    }

    setState(() {
      items = temp;
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();

    incrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoaded
            ? Container(
                padding: EdgeInsets.only(
                    left: Get.width * 0.05, right: Get.width * 0.05),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Upcoming Events",
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return EventDetailsScreen(items[index]["id"]);
                                }),
                              );
                            },
                            child: Column(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: Color(0xffff6b74), width: 0),
                                      borderRadius: BorderRadius.circular(15)),
                                  elevation: 3,
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 2, color: Colors.red),
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
                                      backgroundImage: NetworkImage(
                                          items[index]["admin_image"]),
                                    ),
                                    title: Text(items[index]["event_creator"]),
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                  elevation: 3,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    height: Get.height * 0.45,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(
                                          20,
                                        ),
                                        border: Border.all(
                                            color: Colors.red, width: 2)),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: Get.height * 0.225,
                                          width: Get.width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.network(
                                                items[index]["image"],
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
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.black),
                                                ),
                                                child: Center(
                                                    child: Text(items[index]
                                                        ["start_time"]))),
                                            SizedBox(
                                              width: Get.width * 0.6,
                                              child: Center(
                                                child: Text(
                                                  items[index]["name"],
                                                  style: GoogleFonts.lato(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
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
                                                  items[index]["location"]
                                                      .toString(),
                                                  style: GoogleFonts.lato(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
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
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                height: Get.height,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ));
  }
}
