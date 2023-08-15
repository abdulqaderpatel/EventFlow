import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:eventflow/Views/User/event_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
                color: const Color(0xff404354),
                padding: EdgeInsets.only(
                    left: Get.width * 0.05, right: Get.width * 0.05),
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30)),
                                            child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(
                                                                30),
                                                        topLeft:
                                                            Radius.circular(
                                                                30)),
                                                child: Image.network(
                                                  items[index]["image"],
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                          Positioned(top: Get.height*0.025,right: Get.width*0.076,
                                            child: Container(height:60,width: 60,decoration: BoxDecoration(shape: BoxShape.circle,color: Color(0xff65696E).withOpacity(0.4),),
                                              child: Center(
                                                child: Column(mainAxisAlignment:MainAxisAlignment.center, 
                                                  children: [
                                                    Text(DateFormat("d").format(
                                                      DateTime.parse(
                                                        items[index]
                                                        ["start_time"],
                                                      ),
                                                    ),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                                    Text(DateFormat("MMMM").format(
                                                      DateTime.parse(
                                                        items[index]
                                                        ["start_time"],
                                                      ),
                                                    ),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
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
                                            Container(
                                              width: Get.width * 0.65,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        items[index]["name"],
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white,
                                                            fontSize: 20,
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
                                                        items[index]
                                                            ["location"],
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Text(
                                                        " - ${DateFormat("hh:mm a").format(
                                                          DateTime.parse(
                                                            items[index]
                                                                ["end_time"],
                                                          ),
                                                        )}",
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30),
                                                  color: Colors.white),
                                              child: Text(
                                                "₹ ${items[index]["price"]}",
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600),
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
              )
            : Container(
                height: Get.height,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ));
  }
}
