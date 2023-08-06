import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Misc/Firebase/firebase_tables.dart';

class UserFollowingPageScreen extends StatelessWidget {
  final List<Map<String, dynamic>> followingData;

  UserFollowingPageScreen(this.followingData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Colors.grey,
        child: Container(margin: EdgeInsets.only(left: Get.width*0.05,right: Get.width*0.05),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              const Text("Following",style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount:followingData.length,
                      itemBuilder: (context, index) {
                        return Card(
                            surfaceTintColor: Colors.greenAccent,
                            shadowColor: Colors.blue,
                            margin: const EdgeInsets.only(bottom: 20),
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10),
                                side: const BorderSide(
                                    width: 2, color: Colors.white)),
                            elevation: 5,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    followingData[index]["image"]),
                              ),
                              title: Text(
                                followingData[index]["username"],
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                followingData[index]["name"],
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                              ),

                            ));
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
