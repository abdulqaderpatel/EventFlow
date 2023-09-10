import 'dart:io';

import 'package:eventflow/Reusable_Components/Admin/create_event_text_field.dart';

import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:eventflow/Views/Misc/toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

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
  bool isStartPicked = false;
  TimeOfDay endTime = const TimeOfDay(hour: 0, minute: 0);
  bool isEndPicked = false;
  DateTime selectedDate = DateTime.now();
  bool isDatePicked = false;

  late DateTime eventStart;
  late DateTime eventEnd;

  Future<void> _startTime(BuildContext context) async {
    final TimeOfDay? pickedS =
        await showTimePicker(context: context, initialTime: startTime);

    if (pickedS != null && pickedS != startTime) {
      setState(() {
        startTime = pickedS;
        isStartPicked = true;
      });
    }
    eventStart = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      startTime.hour,
      startTime.minute,
    );
    eventEnd = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      endTime.hour,
      endTime.minute,
    );
  }

  Future<void> _endTime(BuildContext context) async {
    final TimeOfDay? pickedS =
        await showTimePicker(context: context, initialTime: endTime);

    if (pickedS != null && pickedS != endTime) {
      setState(() {
        endTime = pickedS;
        isEndPicked = true;
      });
    }
    eventStart = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      startTime.hour,
      startTime.minute,
    );
    eventEnd = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      endTime.hour,
      endTime.minute,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;

        isDatePicked = true;
      });
    }
    eventStart = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      startTime.hour,
      startTime.minute,
    );
    eventEnd = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      endTime.hour,
      endTime.minute,
    );
  }

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

  List<String> list = <String>[
    "Trekking",
    "Concert",
    "Marathon",
    "Educational",
    "Celebration",
    "Other"
  ];
  String dropdownValue = "Trekking";
  late bool isButtonLoading;

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

  List<Map<String, dynamic>> items = [];

  void getUsernameAndUserImage() async {
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
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    getUsernameAndUserImage();
    isButtonLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: Get.height * 1.16,
          color: const Color(0xff00141C),
          child: Container(
            margin: EdgeInsets.only(
                left: Get.width * 0.08,
                right: Get.width * 0.08,
                top: Get.height * 0.05),
            height: Get.height,
            child: SingleChildScrollView(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CreateEventTextField(
                        text: "Location",
                        controller: locationController,
                        width: Get.width * 0.55,
                      ),
                      CreateEventTextField(
                        text: "Price",
                        controller: priceController,
                        width: Get.width * 0.25,
                        textInputType: TextInputType.number,
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
                            color: Colors.white54,
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
                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Event Category",
                        style: TextStyle(color: Color(0xff616161)),
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: const Color(0xff00141C),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          width: Get.width * 0.5,
                          decoration: BoxDecoration(
                              color:  const Color(0xff4E4654),
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              icon: const Icon(Icons.arrow_downward,color: Colors.white,),
                              elevation: 16,
                              style: const TextStyle(color: Colors.white),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  dropdownValue = value!;
                                });
                              },
                              items: list
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Select Date",
                            style: TextStyle(color: Color(0xff616161)),
                          ),
                          InkWell(
                              onTap: () => _selectDate(context),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xff352D3C),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                child: Text(
                                  !isDatePicked
                                      ? "Please select a date"
                                      : DateFormat('dd-MM-yyyy')
                                          .format(selectedDate),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              )),
                        ],
                      ),
                      CreateEventTextField(
                        text: "Max participants",
                        controller: maxEntries,
                        width: Get.width * 0.4,
                        textInputType: TextInputType.number,
                      ),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Select start time",
                            style: TextStyle(color: Color(0xff616161)),
                          ),
                          InkWell(
                            onTap: () => _startTime(context),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff352D3C),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time_filled),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    !isStartPicked
                                        ? "Select start time"
                                        : startTime.format(context),
                                    style:
                                        const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Select end time",
                            style: TextStyle(color: Color(0xff616161)),
                          ),
                          InkWell(
                            onTap: () => _endTime(context),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff352D3C),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: Color(0xff616161),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    !isEndPicked
                                        ? "Select end time"
                                        : endTime.format(context),
                                    style:
                                        const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  SizedBox(
                    width: Get.width * 0.8,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(  shape:
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                         ), backgroundColor: Colors.purple
                          ,minimumSize: Size(Get.width, 40),textStyle: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500) // Background color
                      ),
                      onPressed: () async {
                        setState(() {
                          isButtonLoading = true;
                        });
                        if (titleController.text.isEmpty) {
                          Toast().errorMessage("Event name cannot be empty");
                          setState(() {
                            isButtonLoading = false;
                          });
                        } else if (locationController.text.isEmpty) {
                          Toast().errorMessage("Location cannot be empty");
                          setState(() {
                            isButtonLoading = false;
                          });
                        } else if (priceController.text.isEmpty) {
                          Toast().errorMessage("Price cannot be empty");
                          setState(() {
                            isButtonLoading = false;
                          });
                        } else if (eventImage == null) {
                          Toast().errorMessage("Image cannot be empty");
                          setState(() {
                            isButtonLoading = false;
                          });
                        } else if (!isDatePicked) {
                          Toast().errorMessage("Event Date cannot be empty");
                          setState(() {
                            isButtonLoading = false;
                          });
                        } else if (maxEntries.text.isEmpty) {
                          Toast().errorMessage(
                              "max participants cannot be empty");
                          setState(() {
                            isButtonLoading = false;
                          });
                        } else if (descriptionController.text.isEmpty) {
                          Toast().errorMessage("Description cannot be empty");
                          setState(() {
                            isButtonLoading = false;
                          });
                        } else if (!isStartPicked) {
                          Toast().errorMessage("start time cannot be empty");
                          setState(() {
                            isButtonLoading = false;
                          });
                        } else if (!isEndPicked) {
                          Toast().errorMessage("End time cannot be empty");
                          setState(() {
                            isButtonLoading = false;
                          });
                        } else if (priceController.text.contains(".") ||
                            priceController.text.contains(".")) {
                          Toast()
                              .errorMessage("Price should be a valid number");
                          setState(() {
                            isButtonLoading = false;
                          });
                        } else if (maxEntries.text.contains(".") ||
                            maxEntries.text.contains(".")) {
                          Toast().errorMessage(
                              "max participants should be a valid number");
                          setState(() {
                            isButtonLoading = false;
                          });
                        } else {
                          Reference ref = FirebaseStorage.instance.ref(
                              "/${FirebaseAuth.instance.currentUser!.uid}/${DateTime.now().millisecondsSinceEpoch.toString()}");
                          UploadTask uploadTask =
                              ref.putFile(eventImage!.absolute);

                          Future.value(uploadTask).then((value) async {
                            var newUrl = await ref.getDownloadURL();
                            var id = DateTime.now()
                                .millisecondsSinceEpoch
                                .toString();
                            setState(() {
                              isButtonLoading = false;
                            });
                            await FirebaseTable().eventsTable.doc(id).set({
                              "event_creator": FirebaseAuth
                                  .instance.currentUser!.displayName,
                              "name": titleController.text.toString(),
                              "username": items[0]["username"],
                              "admin_image": items[0]["image"],
                              "description":
                                  descriptionController.text.toString(),
                              "price":
                                  int.parse(priceController.text.toString()),
                              "image": newUrl.toString(),
                              "max_participants":
                                  int.parse(maxEntries.text.toString()),
                              "start_time": eventStart.toIso8601String(),
                              "end_time": eventEnd.toIso8601String(),
                              "location": locationController.text.toString(),
                              "participants": [],
                              "emails": [],
                              "rating": 0.0,
                              "raters": [],
                              "type": dropdownValue,
                              "id": id,
                            });
                            Toast()
                                .successMessage("Event successfully created");
                          });
                        }
                      },
                      child: isButtonLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              "Create Event",
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
