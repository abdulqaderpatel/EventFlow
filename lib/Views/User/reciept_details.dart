import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RecieptDetailsScreen extends StatefulWidget {
  final String id;

  const RecieptDetailsScreen(this.id, {super.key});

  @override
  State<RecieptDetailsScreen> createState() => _RecieptDetailsScreenState();
}

class _RecieptDetailsScreenState extends State<RecieptDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: Get.height * 1.1,
              color: const Color(0xff0A171F),
              child: Center(
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseTable()
                            .usersTable
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("Reciepts")
                            .where("id", isEqualTo: widget.id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          List<Container> clientWidgets = [];
                          if (snapshot.hasData) {
                            final clients = snapshot.data?.docs;
                            for (var client in clients!) {
                              final clientWidget = Container(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Center(
                                      child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            client["name"],
                                            style: const TextStyle(
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
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
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
                                                client["Date"],
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 30,
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
                                                              FontWeight.w800,
                                                          color: Colors.white),
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
                                                              FontWeight.w500,
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
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      client["bill"].toString(),
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white),
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
                                                            FontWeight.w800,
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    client["price"].toString(),
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SingleChildScrollView(scrollDirection: Axis.horizontal,
                                            child: DataTable(
                                              horizontalMargin: 0,
                                              columns: const [
                                                DataColumn(
                                                    label: Text('NO',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white))),
                                                DataColumn(
                                                    label: Text('Name',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white))),
                                                DataColumn(
                                                    label: Text('Email',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white))),
                                                DataColumn(
                                                    label: Text('Age',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white))),
                                              ],
                                              rows: <DataRow>[
                                                ...client["userdata"].map((e) {
                                                  return DataRow(cells: [
                                                    DataCell(Text(e["no"],
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10))),
                                                    DataCell(Text(e["name"],
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10))),
                                                    DataCell(Text(e["email"],
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10))),
                                                    DataCell(
                                                      Text(e["age"],
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 10)),
                                                    ),
                                                  ]);
                                                })
                                              ],
                                            ),
                                          ),
                                          const Text(
                                              "Please carry along this reciept when attending the event",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                    ],
                                  )),
                                ),
                              );
                              clientWidgets.add(clientWidget);
                            }
                          }
                          return Column(
                            children: clientWidgets,
                          );
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
