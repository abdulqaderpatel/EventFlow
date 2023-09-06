import 'dart:io';
import 'dart:typed_data';

import 'package:eventflow/Views/User/display_events.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class PaymentReciept extends StatelessWidget {
  final List<Map<String, dynamic>> eventData;
  final List<Map<String, dynamic>> userData;
  final List<Map<String, dynamic>> bookedUserData;

  const PaymentReciept(
      {super.key,
      required this.eventData,
      required this.userData,
      required this.bookedUserData});

  Future<void> _shareScreenshot(
      {required BuildContext context, required Widget shareWidget}) async {
    final box = context.findRenderObject() as RenderBox?;
    ScreenshotController()
        .captureFromWidget(shareWidget)
        .then((Uint8List bytes) async {
      final Directory dir = await getApplicationSupportDirectory();
      final String ts = DateTime.now().millisecondsSinceEpoch.toString();
      final String filePath = '${dir.path}/$ts.png';
      await XFile.fromData(bytes).saveTo(filePath);
      await Share.shareXFiles([XFile(filePath)],
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          color: const Color(0xff1C2124),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Your Payment was successful",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white),
                ),
                Column(
                  children: [
                    const Text(
                      "Payment Reciept",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      height: Get.height * 0.17,
                      width: Get.height * 0.17,
                      decoration: BoxDecoration(
                          color: const Color(
                            0xffff8c85,
                          ),
                          borderRadius: BorderRadius.circular(25)),
                      child: Image.asset(
                        "assets/images/main-logo.png",
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    SizedBox(
                      height: 40,
                      child: Text(
                        "EventFlow",
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Bill to: ",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
                              ),
                              Text(
                                FirebaseAuth.instance.currentUser!.displayName
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Bill no: ",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
                              ),
                              Text(
                                DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ]),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Amount: ",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white),
                            ),
                            Text(
                              "${567 * bookedUserData.length}",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Date: ",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white),
                            ),
                            Text(
                              DateFormat('yMMMMd').format(
                                DateTime.parse(
                                  DateTime.now().toString(),
                                ),
                              ),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DataTable(
                      horizontalMargin: 0,
                      columns: [
                        const DataColumn(
                            label: Text('NO',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))),
                        const DataColumn(
                            label: Text('Name',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))),
                        const DataColumn(
                            label: Text('Email',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))),
                        const DataColumn(
                            label: Text('Age',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))),
                      ],
                      rows: <DataRow>[
                        ...bookedUserData.map((e) {
                          return DataRow(cells: [
                            DataCell(Text(e["no"],
                                style: const TextStyle(color: Colors.white))),
                            DataCell(Text(e["name"],
                                style: const TextStyle(color: Colors.white))),
                            DataCell(Text(e["email"],
                                style: const TextStyle(color: Colors.white))),
                            DataCell(
                              Text(e["age"],
                                  style: const TextStyle(color: Colors.white)),
                            ),
                          ]);
                        })
                      ],
                    ),
                    const Text(
                        "Please carry along this reciept when attending the event",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold))
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                        return const DisplayEventsScreen();
                      }));
                      _shareScreenshot(
                          context: context,
                          shareWidget: MediaQuery(
                            data: const MediaQueryData(),
                            child: MaterialApp(
                              home: Scaffold(
                                body: Container(
                                    color: Colors.white,
                                    padding: const EdgeInsets.all(10),
                                    height: Get.height,
                                    width: Get.width,
                                    child: Center(
                                      child: Column(
                                        children: [
                                          const Text(
                                            "Payment Reciept",
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          Container(
                                            height: Get.height * 0.17,
                                            width: Get.height * 0.17,
                                            decoration: BoxDecoration(
                                                color: const Color(
                                                  0xffff8c85,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: Image.asset(
                                              "assets/images/main-logo.png",
                                            ),
                                          ),
                                          SizedBox(
                                            height: Get.height * 0.01,
                                          ),
                                          SizedBox(
                                            height: 40,
                                            child: Text(
                                              "EventFlow",
                                              style: GoogleFonts.roboto(
                                                textStyle: const TextStyle(
                                                    fontSize: 32,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Text(
                                                      "Bill to: ",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ),
                                                    Text(
                                                      FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .displayName
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Text(
                                                      "Bill no: ",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ),
                                                    Text(
                                                      DateTime.now()
                                                          .millisecondsSinceEpoch
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ]),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Amount: ",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                  Text(
                                                    "${567 * bookedUserData.length}",
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Date: ",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                  Text(
                                                    DateFormat('yMMMMd').format(
                                                      DateTime.parse(
                                                        DateTime.now()
                                                            .toString(),
                                                      ),
                                                    ),
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          DataTable(
                                            horizontalMargin: 3,
                                            columns: const [
                                              DataColumn(
                                                  label: Text('NO',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text('Name',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text('Email',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text('Age',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight
                                                              .bold))),
                                            ],
                                            rows: <DataRow>[
                                              ...bookedUserData.map((e) {
                                                return DataRow(cells: [
                                                  DataCell(Text(e["no"])),
                                                  DataCell(Text(e["name"])),
                                                  DataCell(Text(e["email"])),
                                                  DataCell(Text(e["age"])),
                                                ]);
                                              })
                                            ],
                                          ),
                                          const Text(
                                              "Please carry along this reciept when attending the event",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          ));
                    },
                    child: const Text("Get Reciept"))
              ],
            )),
          ),
        ),
      ),
    );
  }
}
