import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Misc/Firebase/firebase_tables.dart';
class SearchFriendsScreen extends StatefulWidget {
  const SearchFriendsScreen({super.key});

  @override
  State<SearchFriendsScreen> createState() => _SearchFriendsScreenState();
}

class _SearchFriendsScreenState extends State<SearchFriendsScreen> {

  String mToken="";

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

  void getToken()async
  {
    await FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        mToken=value!;
      });
      saveToken(value!);
    });
  }

  void saveToken(String token)async{
    await FirebaseTable().usersTable.doc(FirebaseAuth.instance.currentUser!.uid).update({"token":token});

  }

  void sendPushMessage(String token,String body,String title)async{

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

  void initInfo()async{
    DocumentSnapshot snap=await FirebaseTable().usersTable.doc(FirebaseAuth.instance.currentUser!.uid).get();
    String token=snap["token"];
    print(token);

    sendPushMessage(token, "timepass", "just testing");
  }

@override
  void initState() {
    requestPermission();
    getToken();
    initInfo();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            sendPushMessage("fIOc2hYgRDqrBfKsSCCD-q:APA91bGXZeLiWDh88jAPD6nENgV1alqt7P-a2Y3oWvDVg_GIhUcKKMxGAwkWeQNHLFgT7sTm6CckTXAtS9xpty3M_5TlUAZOGrS69EPJSGEhd4ecMtITX2SJImzLI7OxSDHo2hVSDb42", "hello", "dfdefd");
          },child: Text("Press"),
        ),
      ),
    );
  }
}
