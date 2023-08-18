import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserFollowerPageScreen extends StatelessWidget {
  final List<Map<String, dynamic>> followerData;

  const UserFollowerPageScreen(this.followerData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color:  const Color(0xff0A171F),
        child: Container(
          margin:
              EdgeInsets.only(left: Get.width * 0.025, right: Get.width * 0.025),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Followers",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: followerData.length,
                      itemBuilder: (context, index) {
                        return Card(

                            margin: const EdgeInsets.only(bottom: 20),
                            color:  const Color(0xff0A171F),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                ),
                            elevation: 5,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(followerData[index]["image"]),
                              ),
                              title: Text(
                                followerData[index]["username"],
                                style: const TextStyle(color: Colors.white,
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                followerData[index]["name"],
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
