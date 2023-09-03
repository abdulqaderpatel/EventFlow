import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/Reusable_Components/User/user_details_field.dart';
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:eventflow/Views/User/Profile/edit_user_profile.dart';
import 'package:eventflow/Views/User/Profile/user_follower_page.dart';
import 'package:eventflow/Views/User/Profile/user_following_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Authentication/admin_or_user.dart';
import '../../Misc/toast/toast.dart';
import 'edit_admin_profile.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final usernameController = TextEditingController();

  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final phoneNumberController = TextEditingController();

  FirebaseStorage storage = FirebaseStorage.instance;

  void requestPermission() async{
    var firebaseMessage=FirebaseMessaging.instance;
    NotificationSettings settings=await firebaseMessage.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: false,
        sound: true
    );
    if(settings.authorizationStatus==AuthorizationStatus.authorized)
    {
      print("granted");
    }
    else if(settings.authorizationStatus==AuthorizationStatus.provisional)
    {
      print("provisional");
    }
    else{
      print("revoked");
    }
  }

  void sendPushMessage(List<dynamic> token,String body,String title)async{

    try{
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String,String>{
            'Content-Type':"application/json",
            "Authorization":"key=AAAAzyRvaDI:APA91bGXHlILnAiR7dKA_7Iv7H2kz1B7GQK8qRzXWG2_qjSqC9qIm5B0AmTIqnKCu81aQHfCbMlDwJQsBfE63u551WdwkMzVPy7bzTwboCriebPK2x1TV9SWyvqTAVCCjqDTYkC3epQn"
          },
          body: jsonEncode(<String,dynamic>{
            "priority":"high",
            "data":<String,dynamic>{
              "click_action":"FLUTTER_NOTIFICATION_CLICK",
              "status":"done",
              "body":body,
              "title":title
            },
            "notification":<String,dynamic>{
              "title":title,
              "body":body,
              "android_channel_id":"dbfood"
            },
            "to":token
          })
      );
    }
    catch(e)
    {

    }
  }

void initDetails()async{
  DocumentSnapshot snap=await FirebaseTable().eventsTable.doc("1693758139569").get();
  List<dynamic> token=snap["token"];
  print(token);

}


  @override
  void initState() {
  requestPermission();
  initDetails();



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseTable()
                .adminsTable
                .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              List<SingleChildScrollView> clientWidgets =
              [];
              if (snapshot.hasData) {
                final clients = snapshot.data?.docs;
                for (var client in clients!) {
                  final clientWidget =
                  SingleChildScrollView(
                    child: Container(
                      height: Get.height,
                      color: const Color(0xff111111),
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 40, bottom: 20),
                              decoration: const BoxDecoration(
                                color: Color(0xff111111),
                              ),
                              width: Get.width,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            await FirebaseAuth.instance.signOut();
                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                      return const AdminOrUserScreen();
                                                    }));
                                            Toast().successMessage(
                                                "Logged out successfully");
                                          },
                                          focusColor: Colors.blue,
                                          child: const Icon(
                                            Icons.logout,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          client["name"],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 23,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                      return const EditAdminProfileScreen();
                                                    }));
                                          },
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Container(
                                    margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: client["image"] == null
                                              ? const CircleAvatar(
                                            radius: 60,
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: Colors.blue,
                                              size: 50,
                                            ),
                                          )
                                              : CircleAvatar(
                                            radius: 56,
                                            backgroundColor: Colors.white,
                                            backgroundImage: NetworkImage(
                                              client["image"],
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Get.width * 0.02),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    children: [
                                      UserDetailField(
                                          icon: Icons.supervised_user_circle,
                                          placeholder: "username",
                                          details: client["username"]),
                                      SizedBox(
                                        width: Get.width * 0.05,
                                      ),
                                      UserDetailField(
                                          icon: Icons.email,
                                          placeholder: "email",
                                          details: client["email"]),
                                    ],

                                  ),
                                  SizedBox(height: Get.height*0.05,),
                                  Row(
                                    children: [
                                      UserDetailField(
                                          icon: Icons.phone,
                                          placeholder: "phone number",
                                          details:
                                          client["phone_number"].toString()),
                                      SizedBox(
                                        width: Get.width * 0.05,
                                      ),
                                     ElevatedButton(onPressed: ()async{
                                       DocumentSnapshot snap=await FirebaseTable().eventsTable.doc("1693758139569").get();
                                       List<dynamic> token=snap["token"];
                                       print(token);

                                       sendPushMessage(token, "timepass", "just testing");

                                     }, child: Text("notify")),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                  clientWidgets.add(clientWidget);
                }
              }
              else {

                final clientWidget = SingleChildScrollView(
                  child: Container(color: const Color(0xff111111),),);
                clientWidgets.add(clientWidget);
              }

              return Column(
                children: clientWidgets,
              );
            }),
      ),
    );
  }
}
