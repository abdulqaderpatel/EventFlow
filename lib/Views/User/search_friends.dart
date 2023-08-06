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
  var isLoaded = false;

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



    setState(() {
      items = temp;
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    getUsernameAndUserImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoaded
            ? Container(
                color: Colors.redAccent,
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
                                  return Card(surfaceTintColor: Colors.greenAccent,shadowColor: Colors.blue,margin: EdgeInsets.only(bottom: 20),color: Colors.red,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: const BorderSide(
                                            width: 2, color: Colors.white)),
                                    elevation: 5,
                                    child: ListTile(

                                      leading: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(items[index]["image"]),
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
                                    ),
                                  );
                                }))
                      ],
                    ),
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()));
  }
}
