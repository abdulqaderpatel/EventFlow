import 'dart:async';


import 'package:eventflow/Views/Misc/toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class VerifyEmailScreen extends StatefulWidget {
  final String username;
  const VerifyEmailScreen({super.key,required this.username});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  String svgImage = "assets/images/email_sent.svg";

  var loadingIcons = 0;
  var loadingString = "";
  var isVerified = false;
  late Timer timer;

  void emailVerificationLoading() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer t) {
      if (isVerified == false) {
        if (loadingIcons == 8) {
          setState(() {
            loadingIcons = 1;
            loadingString = ". ";
          });
        } else {
          setState(() {
            loadingIcons++;
            loadingString += ". ";
          });
        }
      }
    });
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
    Toast().errorMessage(e.toString());
    }
  }

  @override
  void initState() {
    isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        checkEmailVerified();
      });
    }
    emailVerificationLoading();

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isVerified) {
      setState(() {
        svgImage = "assets/images/email_verified.svg";
      });
      timer.cancel();
      Toast().errorMessage("Redirecting..");
      // await FirebaseTable()
      //     .usersTable
      //     .doc(FirebaseAuth.instance.currentUser!.uid)
      //     .set({
      //   "id": FirebaseAuth.instance.currentUser!.uid,
      //   "name": FirebaseAuth.instance.currentUser!.displayName,
      //   "username":widget.username,
      //   "email": FirebaseAuth.instance.currentUser!.email,
      //   "profile_picture": "",
      //   "bio":"",
      //   "phone_number":"",
      //   "followers":[],
      //   "following":[]
      // });
      // await Future.delayed(const Duration(seconds: 1));
      // if (context.mounted) {
      //   Navigator.pushReplacement(context,
      //       MaterialPageRoute(builder: (context) {
      //         return UserNavigationBar();
      //       }));
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
              left: Get.width * 0.05, right: Get.width * 0.05, top: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        // Navigator.pushReplacement(context,
                        //     MaterialPageRoute(builder: (context) {
                        //       return SignupScreen();
                        //     }));
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Gap(3),
                   const Text(
                      "Go Back",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color:  Colors.white
                              ),
                    ),
                  ],
                ),
                Gap(Get.height * 0.01),
                // SizedBox(
                //   height: Get.height * 0.25,
                //   child:
                //   SvgPicture.asset(svgImage, semanticsLabel: 'Acme Logo'),
                // ),
                isVerified
                    ? Column(
                  children: [
                    Gap(
                      Get.height * 0.05,
                    ),
                    Text(
                      "Email Verified",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Gap(Get.height * 0.04),
                    Text(
                      "Redirecting..",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    Gap(Get.height * 0.05),
                    const CircularProgressIndicator()
                  ],
                )
                    : Column(
                  children: [
                    Gap(Get.height * 0.03),
                    Text(
                      "Check your email",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Gap(Get.height * 0.02),
                    const Text(
                      "A verification email has been sent to the email provided by you. Kindly confirm the email by tapping the button below",
                    ),
                    Gap(Get.height * 0.1),
                    SizedBox(
                      height: Get.height * 0.06,
                      width: Get.width,
                      child: ElevatedButton(
                        onPressed: () {
                          // AndroidIntent intent = const AndroidIntent(
                          //     action: 'android.intent.action.MAIN',
                          //     category:
                          //     'android.intent.category.APP_EMAIL',
                          //     flags: [Flag.FLAG_ACTIVITY_NEW_TASK]);
                          // intent.launch().catchError((e) {});
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                            Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: Text(
                          "Check Email",
                          style: GoogleFonts.lato(
                              letterSpacing: 0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    Gap(Get.height * 0.05),
                    Text(
                      loadingString,
                      style: const TextStyle(
                          fontSize: 24, color: Colors.blue),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
