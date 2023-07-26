import 'dart:io';

import 'package:eventflow/Controllers/Users/user_Controller.dart';
import 'package:eventflow/Screens/Misc/Firebase/firebase_tables.dart';
import 'package:eventflow/Screens/Misc/toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final usernameController = TextEditingController();

  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final phoneNumberController = TextEditingController();

  FirebaseStorage storage = FirebaseStorage.instance;

  File? profileImage;

  final picker = ImagePicker();

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    } else {
      Toast().errorMessage("Please choose an image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    getImageGallery();
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    margin: const EdgeInsets.only(top: 35),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(70),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff7DDCFB),
                          Color(0xffBC67F2),
                          Color(0xffACF6AF),
                          Color(0xffF95549),
                        ],
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(70),
                      ),
                      child: profileImage == null
                          ? CircleAvatar(
                              radius: 56,
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
                              backgroundImage: FileImage(
                                profileImage!,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 2, left: 3),
                        errorStyle: const TextStyle(fontSize: 0),
                        hintStyle: const TextStyle(
                          color: Colors.black38,
                        ),
                        hintText: "Enter username",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 2, left: 3),
                        errorStyle: const TextStyle(fontSize: 0),
                        hintStyle: const TextStyle(
                          color: Colors.black38,
                        ),
                        hintText: "Enter first name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 2, left: 3),
                        errorStyle: const TextStyle(fontSize: 0),
                        hintStyle: const TextStyle(
                          color: Colors.black38,
                        ),
                        hintText: "Enter last name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 2, left: 3),
                        errorStyle: const TextStyle(fontSize: 0),
                        hintStyle: const TextStyle(
                          color: Colors.black38,
                        ),
                        hintText: "Enter phone number",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: Get.width * 0.8,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xff223b55)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: () async {
                      Reference ref =
                          FirebaseStorage.instance.ref("/${FirebaseAuth.instance.currentUser!.uid}/profile_picture");
                      UploadTask uploadTask =
                          ref
                          .putFile(profileImage!.absolute);
                     Future.value(uploadTask).then((value)async {
                       var newUrl=ref.getDownloadURL();
                       await FirebaseTable().usersTable.doc(FirebaseAuth.instance.currentUser!.uid).update({"image":newUrl.toString()});
                     } );

                      

                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
