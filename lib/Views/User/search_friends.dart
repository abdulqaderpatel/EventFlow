import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Misc/Firebase/firebase_tables.dart';
import 'package:get/get.dart';

class SearchFriendsScreen extends StatefulWidget {
  const SearchFriendsScreen({super.key});

  @override
  State<SearchFriendsScreen> createState() => _SearchFriendsScreenState();
}

class _SearchFriendsScreenState extends State<SearchFriendsScreen> {
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> user = [];
  var isLoaded = false;
  List<bool> following = [];

  void getUsernameAndUserImage() async {
    List<Map<String, dynamic>> temp = [];
    var data = await FirebaseTable()
        .usersTable
        .where("email", isNotEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    for (var element in data.docs) {
      setState(() {
        temp.add(element.data());
      });
    }

    items = temp;
    for (int i = 0; i < items.length; i++) {
      var followersData = await FirebaseTable()
          .followingTable
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("userFollowing")
          .doc(items[i]["email"])
          .get();

      if (followersData.exists) {
        following.add(false);
      } else {
        following.add(true);
      }
    }

    temp = [];

    var userData = await FirebaseTable()
        .usersTable
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    for (var element in userData.docs) {
      temp.add(element.data());
    }

    user = temp;

    if (mounted) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUsernameAndUserImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoaded
            ? Container(
                color: const Color(0xff0A171F),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Add Friends",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                            child: ListView.builder(
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  return Card(

                                      margin: const EdgeInsets.only(bottom: 20),
                                      color: const Color(0xff0A171F),


                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              items[index]["image"]),
                                        ),
                                        title: Text(
                                          items[index]["username"],
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        subtitle: Text(
                                          items[index]["name"],
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        trailing: ElevatedButton(
                                          onPressed: () {
                                            FirebaseTable()
                                                .followingTable
                                                .doc(FirebaseAuth.instance
                                                    .currentUser!.email)
                                                .collection("userFollowing")
                                                .doc(items[index]["email"])
                                                .get()
                                                .then((value) {
                                              if (value.exists) {
                                                FirebaseTable()
                                                    .followerTable
                                                    .doc(items[index]["email"])
                                                    .collection("userFollower")
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser!.email)
                                                    .delete();
                                                FirebaseTable()
                                                    .followingTable
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser!.email)
                                                    .collection("userFollowing")
                                                    .doc(items[index]["email"])
                                                    .delete()
                                                    .then((value) {
                                                  setState(() {
                                                    following[index] = true;
                                                  });
                                                });
                                              } else {
                                                FirebaseTable()
                                                    .followerTable
                                                    .doc(items[index]["email"])
                                                    .collection("userFollower")
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser!.email)
                                                    .set(user[0])
                                                    .then((value) => null);
                                                FirebaseTable()
                                                    .followingTable
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser!.email)
                                                    .collection("userFollowing")
                                                    .doc(items[index]["email"])
                                                    .set(items[index])
                                                    .then((value) {
                                                  setState(() {
                                                    following[index] = false;
                                                  });
                                                });
                                              }
                                            });
                                          },
                                          child: Text(
                                            following[index]
                                                ? "Follow"
                                                : "Unfollow",
                                            style: const TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ));
                                }))
                      ],
                    ),
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()));
  }
}
