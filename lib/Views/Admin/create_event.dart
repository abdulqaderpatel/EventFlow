import 'dart:io';

import 'package:eventflow/Reusable_Components/Admin/admin_text_field.dart';
import 'package:eventflow/Reusable_Components/Admin/create_event_text_field.dart';
import 'package:eventflow/Reusable_Components/Admin/create_event_text_field.dart';
import 'package:eventflow/Reusable_Components/Admin/create_event_text_field.dart';
import 'package:eventflow/Reusable_Components/Admin/create_event_text_field.dart';
import 'package:eventflow/Reusable_Components/Admin/create_event_text_field.dart';
import 'package:eventflow/Reusable_Components/Admin/create_event_text_field.dart';
import 'package:eventflow/Reusable_Components/Admin/create_event_text_field.dart';
import 'package:eventflow/Reusable_Components/Admin/create_event_text_field.dart';
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:eventflow/Views/Misc/toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';

class CreateEventScreen extends StatefulWidget {
  CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  TextEditingController dateController = TextEditingController();

  TextEditingController timeController = TextEditingController();

  TextEditingController titleController = TextEditingController();

  TextEditingController locationController = TextEditingController();

  TextEditingController priceController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  TextEditingController tagsController = TextEditingController();

  TextEditingController maxEntries = TextEditingController();

  TextEditingController endTimeController = TextEditingController();

  TextEditingController startTimeController = TextEditingController();

  TextEditingController frequencyEventController = TextEditingController();

  TimeOfDay startTime = const TimeOfDay(hour: 0, minute: 0);

  TimeOfDay endTime = const TimeOfDay(hour: 0, minute: 0);

  var selectedFrequency = -2;

  void resetControllers() {
    dateController.clear();
    timeController.clear();
    titleController.clear();
    locationController.clear();
    priceController.clear();
    descriptionController.clear();
    tagsController.clear();
    maxEntries.clear();
    endTimeController.clear();
    startTimeController.clear();
    frequencyEventController.clear();
    startTime = const TimeOfDay(hour: 0, minute: 0);
    endTime = const TimeOfDay(hour: 0, minute: 0);
  }

  FirebaseStorage storage = FirebaseStorage.instance;

  File? eventImage;

  final picker = ImagePicker();

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        eventImage = File(pickedFile.path);
      });
    } else {
      Toast().errorMessage("Please choose an image");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: EdgeInsets.only(
              left: Get.width * 0.08,
              right: Get.width * 0.08,
              top: Get.height * 0.05),
          height: Get.height,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  CreateEventTextField(
                    text: "Event name",
                    controller: titleController,
                    width: Get.width,
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CreateEventTextField(
                        text: "Location",
                        controller: locationController,
                        width: Get.width*0.55,
                      ),
                      CreateEventTextField(
                        text: "Price",
                        controller: priceController,
                        width: Get.width*0.25,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  InkWell(
                    onTap: () {
                      getImageGallery();
                    },
                    child: eventImage == null
                        ? DottedBorder(
                            strokeWidth: 2,
                            color: Colors.grey,
                            child: SizedBox(
                              height: Get.height * 0.22,
                              child: const Center(
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue)),
                            child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.file(
                                  eventImage!,
                                  fit: BoxFit.cover,
                                )),
                          ),
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CreateEventTextField(
                          text: "Event Date",
                          controller: dateController,
                          width: Get.width * 0.4),
                      CreateEventTextField(
                          text: "Max participants",
                          controller: maxEntries,
                          width: Get.width * 0.4),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  CreateEventTextField(
                    text: "Description",
                    controller: descriptionController,
                    width: Get.width,
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CreateEventTextField(
                          text: "Start time",
                          controller: startTimeController,
                          width: Get.width * 0.4,
                      ),
                      CreateEventTextField(
                        text: "End time",
                        controller: endTimeController,
                        width: Get.width * 0.4,

                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
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
                        Reference ref = FirebaseStorage.instance.ref(
                            "/${FirebaseAuth.instance.currentUser!.uid}/events/${titleController.text}");
                        UploadTask uploadTask =
                            ref.putFile(eventImage!.absolute);
                        Future.value(uploadTask).then((value) async {
                          var newUrl = await ref.getDownloadURL();
                          await FirebaseTable()
                              .eventsTable
                              .doc(DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString())
                              .set({
                            "event_creator":FirebaseAuth.instance.currentUser!.displayName,
                            "name":titleController.text.toString(),
                            "description":descriptionController.text.toString(),
                            "price":int.parse(priceController.text.toString()),
                            "image":newUrl.toString(),
                            "date":dateController.text.toString(),
                            "max_participants":maxEntries.text.toString(),
                            "start_time":startTimeController.text.toString(),
                            "end_time":endTimeController.text.toString(),
                            "location":locationController.text.toString(),

                          });
                          Toast().successMessage("Event successfully created");
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
        ));
  }
}
