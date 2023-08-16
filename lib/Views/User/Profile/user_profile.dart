import 'package:eventflow/Reusable_Components/User/user_details_field.dart';
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:eventflow/Views/User/Profile/edit_user_profile.dart';
import 'package:eventflow/Views/User/Profile/user_follower_page.dart';
import 'package:eventflow/Views/User/Profile/user_following_page.dart';
import 'package:eventflow/Views/User/user_enrolled_events.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Authentication/admin_or_user.dart';
import '../../Misc/toast/toast.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final usernameController = TextEditingController();

  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final phoneNumberController = TextEditingController();

  FirebaseStorage storage = FirebaseStorage.instance;

  late List<Map<String, dynamic>> items;
  bool isLoaded = false;

  late List<Map<String, dynamic>> followingItems;
  late List<Map<String, dynamic>> followerItems;
  List<Map<String,dynamic>> eventItems=[];
  List<Map<String,dynamic>> userEnrolledEventItems=[];
  int userEvents=0;

  void incrementCounter() async {
    List<Map<String, dynamic>> followingTemp = [];
    List<Map<String, dynamic>> followerTemp = [];

    var followingData = await FirebaseTable()
        .followingTable
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("userFollowing")
        .get();

    var followerData = await FirebaseTable()
        .followerTable
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("userFollower")
        .get();

    var eventData = await FirebaseTable()
        .eventsTable
        .get();

    for (var element in followingData.docs) {
      followingTemp.add(element.data());
    }
    followingItems = followingTemp;

    for (var element in followerData.docs) {
      followerTemp.add(element.data());
    }

    followerItems = followerTemp;

    for (var element in eventData.docs) {
      eventItems.add(element.data());
    }

    for(int i=0;i<eventItems.length;i++)
      {
        if(eventItems[i]["participants"].contains(FirebaseAuth.instance.currentUser!.email))
          {
            userEnrolledEventItems.add(eventItems[i]);
            userEvents++;
          }
      }



    List<Map<String, dynamic>> temp = [];
    var data = await FirebaseTable()
        .usersTable
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    for (var element in data.docs) {
      temp.add(element.data());
    }
    items = temp;

    setState(() {
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
            ? SingleChildScrollView(
                child: Container(
                  height: Get.height,
                  color: Color(0xff111111),
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
                                      child: const Icon(
                                        Icons.logout,
                                        color: Colors.white,
                                      ),
                                      focusColor: Colors.blue,
                                    ),
                                    Text(
                                      items[0]["name"],
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
                                          return const EditUserProfileScreen();
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
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: items[0]["image"] == null
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
                                                items[0]["image"],
                                              ),
                                            ),
                                    ),
                                    Column(
                                      children: [
                                        const Text(
                                          "Followers",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return UserFollowerPageScreen(
                                                  followerItems);
                                            }));
                                          },
                                          child: Text(
                                            followerItems.length.toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const Text(
                                          "Following",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return UserFollowingPageScreen(
                                                  followingItems);
                                            }));
                                          },
                                          child: Text(
                                            followingItems.length.toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        )
                                      ],
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
                                      details: items[0]["username"]),
                                  SizedBox(
                                    width: Get.width * 0.05,
                                  ),
                                  UserDetailField(
                                      icon: Icons.email,
                                      placeholder: "email",
                                      details: items[0]["email"]),
                                ],

                              ),
                              SizedBox(height: Get.height*0.05,),
                              Row(
                                children: [
                                  UserDetailField(
                                      icon: Icons.phone,
                                      placeholder: "phone number",
                                      details:
                                          items[0]["phone_number"].toString()),
                                  SizedBox(
                                    width: Get.width * 0.05,
                                  ),
                                  UserDetailField(
                                      icon: Icons.event,
                                      placeholder: "Enrolled events",
                                      details: userEvents.toString(),voidCallback:()=>Navigator.push(context, MaterialPageRoute(builder: (context){
                                        return UserEnrolledEventsScreen(userEnrolledEventItems);
                                  })) ,),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
