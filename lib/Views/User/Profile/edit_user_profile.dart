import 'dart:io';


import 'package:eventflow/Reusable_Components/User/user_text_field.dart';
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:eventflow/Views/Misc/toast/toast.dart';

import 'package:eventflow/Views/User/user_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditUserProfileScreen extends StatefulWidget {
  const EditUserProfileScreen({super.key});

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
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


   List<Map<String, dynamic>> items=[];
  bool isLoaded = false;

  void incrementCounter() async {
    List<Map<String, dynamic>> temp = [];
    var data = await FirebaseTable()
        .usersTable
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    for (var element in data.docs) {
      setState(() {
        temp.add(element.data());
      });
    }

    setState(() {
      items = temp;

    });
    nameController.text=items[0]["name"];
    usernameController.text=items[0]["username"];
    emailController.text=items[0]["email"];
    phoneNumberController.text=items[0]["phone_number"].toString();

    setState(() {
      isLoaded=true;
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
      body:isLoaded? Container(
        height: Get.height,
        color: Colors.redAccent,
        child: Container(padding: const EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const Text("Edit Profile",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 25),),
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
                        child: profileImage != null
                            ? CircleAvatar(
                          radius: 56,
                          backgroundColor: Colors.white,
                          backgroundImage: FileImage(
                            profileImage!,
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
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  UserTextField(
                      text: items[0]["name"],
                      controller: nameController,
                      width: Get.width * 0.8,
                    labelText: "Name",
                    validator: (value){
                        return null;
                    },
                ),
                  const SizedBox(
                    height: 30,
                  ),
                  UserTextField(
                      text: "Username",
                      controller: usernameController,
                      width: Get.width * 0.8,
                  labelText: "Username",
                    validator: (value){
                      return null;
                    },),
                  const SizedBox(
                    height: 30,
                  ),
                  UserTextField(
                      text: "Email",
                      controller: emailController,
                      width: Get.width * 0.8,
                  labelText: "Email",
                    validator: (value){
                      return null;
                    },
                  enabled: false,),
                  const SizedBox(
                    height: 30,
                  ),
                  UserTextField(
                      text: "Phone number",
                      controller: phoneNumberController,
                      width: Get.width * 0.8,labelText: "Phone number",
                    validator: (value){
                      return null;
                    },),

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

                        if(profileImage==null)
                          {
                            await FirebaseTable()
                                .usersTable
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({
                              "username":usernameController.text,
                              "name":nameController.text,
                              "phone_number":phoneNumberController.text
                            });
                            Toast().successMessage(
                                "Profile updated successfully");
                            Get.to(UserNavigationBar());
                          }
                        else {
                          UploadTask uploadTask =

                          ref.putFile(profileImage!.absolute);
                          Future.value(uploadTask).then((value) async {
                            var newUrl = await ref.getDownloadURL();
                            await FirebaseTable()
                                .usersTable
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({"image": newUrl.toString(),
                              "username": usernameController.text,
                              "name": nameController.text,
                              "phone_number": phoneNumberController.text
                            });

                            Toast().successMessage(
                                "Profile updated successfully");
                            Get.to(UserNavigationBar());
                          });
                        }
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
      ):const Center(child: CircularProgressIndicator(),),
    );
  }
}
