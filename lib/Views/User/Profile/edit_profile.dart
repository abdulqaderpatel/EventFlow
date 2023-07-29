import 'dart:io';

import 'package:eventflow/Reusable_Components/User/user_details_field.dart';
import 'package:eventflow/Reusable_Components/User/user_text_field.dart';
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:eventflow/Views/Misc/toast/toast.dart';
import 'package:eventflow/Views/User/Profile/user_profile.dart';
import 'package:eventflow/Views/User/user_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final usernameController = TextEditingController();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

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
        height: Get.height,
        color: Colors.redAccent,
        child: Container(padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Text("Edit Profile",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 25),),
                  InkWell(
                    onTap: () {
                      getImageGallery();
                    },
                    child: Container(
                      width: 120,
                      height: 120,
                      margin: const EdgeInsets.only(top: 45, bottom: 30),
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
                            ? const CircleAvatar(
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
                  UserTextField(
                      text: "Name",
                      controller: nameController,
                      width: Get.width * 0.8),
                  const SizedBox(
                    height: 30,
                  ),
                  UserTextField(
                      text: "Username",
                      controller: usernameController,
                      width: Get.width * 0.8),
                  const SizedBox(
                    height: 30,
                  ),
                  UserTextField(
                      text: "Email",
                      controller: emailController,
                      width: Get.width * 0.8),
                  const SizedBox(
                    height: 30,
                  ),
                  UserTextField(
                      text: "Phone number",
                      controller: phoneNumberController,
                      width: Get.width * 0.8),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: Get.width * 0.8,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xffff0000)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: () async {
                        Reference ref = FirebaseStorage.instance.ref(
                            "/${FirebaseAuth.instance.currentUser!.uid}/profile_picture");
                        UploadTask uploadTask =
                            ref.putFile(profileImage!.absolute);
                        Future.value(uploadTask).then((value) async {
                          var newUrl = await ref.getDownloadURL();
                          await FirebaseTable()
                              .usersTable
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({"image": newUrl.toString(),
                            "username":usernameController.text,
                            "name":nameController.text,
                            "phone_number":int.parse(phoneNumberController.text)
                          });
                          Toast().successMessage("Profile updated successfully");
                          Get.to(UserNavigationBar());
                        });
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
      ),
    );
  }
}
