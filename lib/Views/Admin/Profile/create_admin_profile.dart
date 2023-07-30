import 'dart:io';

import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:eventflow/Views/Misc/toast/toast.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Reusable_Components/Admin/admin_text_field.dart';
import '../admin_navigation_bar.dart';

class CreateAdminProfileScreen extends StatefulWidget {
  const CreateAdminProfileScreen({super.key});

  @override
  State<CreateAdminProfileScreen> createState() =>
      _CreateAdminProfileScreenState();
}

class _CreateAdminProfileScreenState extends State<CreateAdminProfileScreen> {
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

  List<Map<String, dynamic>> items = [];
  bool isLoaded = false;

  void incrementCounter() async {
    List<Map<String, dynamic>> temp = [];
    var data = await FirebaseTable()
        .adminsTable
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

    setState(() {
      isLoaded = true;
      nameController.text = items[0]["name"];

      emailController.text = items[0]["email"];
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    incrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoaded
          ? Container(
              height: Get.height,
              color: const Color(0xff0047AB),
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        const Text(
                          "Set up your Profile",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 25),
                        ),
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
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              AdminTextField(
                                text: items[0]["name"],
                                controller: nameController,
                                width: Get.width * 0.8,
                                labelText: "Name",
                                enabled: false,
                                validator: (value) {
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              AdminTextField(
                                text: "Username",
                                controller: usernameController,
                                width: Get.width * 0.8,
                                labelText: "Username",
                                validator: (value) {
                                  print(value);

                                  return "";
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              AdminTextField(
                                text: "Email",
                                controller: emailController,
                                width: Get.width * 0.8,
                                labelText: "Email",
                                enabled: false,
                                validator: (value) {
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              AdminTextField(
                                text: "Phone number",
                                controller: phoneNumberController,
                                width: Get.width * 0.8,
                                labelText: "Phone number",
                                validator: (value) {
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              SizedBox(
                                width: Get.width * 0.8,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xff0000ff)),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                  ),
                                  onPressed: () async {
                                    if (profileImage == null) {
                                      Toast().errorMessage(
                                          "Please choose a profile image");
                                    } else if (usernameController
                                        .text.isEmpty) {
                                      Toast().errorMessage(
                                          "Username cannot be null");
                                    } else if (phoneNumberController
                                        .text.isEmpty) {
                                      Toast().errorMessage(
                                          "Phone number cannot be empty");
                                    } else if (!RegExp(r'^[a-zA-Z0-9]+$')
                                        .hasMatch(usernameController.text)) {
                                      Toast().errorMessage(
                                          "please enter a valid username");
                                    }
                                    else if(phoneNumberController.text.length!=10)
                                      {
                                        Toast().errorMessage("Invalid phone number");
                                      }
                                    else {
                                      Reference ref = FirebaseStorage.instance.ref(
                                          "/${FirebaseAuth.instance.currentUser!.uid}/profile_picture");
                                      UploadTask uploadTask =
                                          ref.putFile(profileImage!.absolute);
                                      Future.value(uploadTask)
                                          .then((value) async {
                                        var newUrl = await ref.getDownloadURL();
                                        await FirebaseTable()
                                            .adminsTable
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .update({
                                          "image": newUrl.toString(),
                                          "username": usernameController.text,
                                          "phone_number":
                                              phoneNumberController.text
                                        });
                                        Toast().successMessage(
                                            "Profile updated successfully");
                                        Get.to(AdminNavigationBar());
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
                      ],
                    ),
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
