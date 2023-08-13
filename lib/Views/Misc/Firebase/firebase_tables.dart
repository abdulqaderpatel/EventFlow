import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
 class  FirebaseTable extends StatelessWidget {

  final usersTable=FirebaseFirestore.instance.collection("Users");
  final adminsTable=FirebaseFirestore.instance.collection("admins");
  final eventsTable=FirebaseFirestore.instance.collection("events");
  final followingTable=FirebaseFirestore.instance.collection("following");
  final followerTable=FirebaseFirestore.instance.collection("follower");
  final chatTable=FirebaseFirestore.instance.collection("chat");

  FirebaseTable({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }


}
