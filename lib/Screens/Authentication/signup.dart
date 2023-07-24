import 'package:eventflow/Reusable_Components/Authentication/auth_button.dart';
import 'package:eventflow/Screens/Misc/toast.dart';
import 'package:eventflow/Screens/User/display_events.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: Get.width * 0.1,
            right: Get.width * 0.1,
            top: MediaQuery.of(context).size.height * 0.07,
            bottom: MediaQuery.of(context).size.height * 0.08,
          ),
          decoration: BoxDecoration(
              border: Border.all(
                width: 3,
                color: Colors.black,
              ),
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xffff8a78),
                    Color(0xffff6b74),
                    Color(0xffff3f6f),
                  ])),
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: Get.height * 0.1,
                      width: Get.height * 0.1,
                      decoration: BoxDecoration(
                          color: const Color(
                            0xffff8c85,
                          ),
                          borderRadius: BorderRadius.circular(25)),
                      child: Image.asset(
                        "assets/images/main-logo.png",
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: Get.width * 0.05),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                            child: Text(
                              "EventFlow",
                              style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    fontSize: 32,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Text(
                            "The Event managing app",
                            style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xfffdb76b),
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Container(
                  alignment: Alignment.topCenter,
                  width: Get.width * 0.3,
                  height: Get.height * 0.16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color(0xffff8a84),
                  ),
                  child: Center(
                    child: Text(
                      "Sign up",
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            letterSpacing: 0.2,
                            color: Colors.white,
                            decorationColor: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                AuthButton("Name", Icons.person, nameController, false),
                SizedBox(height: Get.height * 0.03),
                AuthButton("Email", Icons.email, emailController, false),
                SizedBox(height: Get.height * 0.03),
                AuthButton("Password", Icons.key, passwordController, true),
                SizedBox(height: Get.height * 0.05),
                InkWell(
                  onTap: () {
                    if (nameController.text.isEmpty) {
                      Toast().errorMessage("Name field cannot be empty");
                    } else if (emailController.text.isEmpty) {
                      Toast().errorMessage("Email field cannot be empty");
                    } else if (passwordController.text.isEmpty) {
                      Toast().errorMessage("Password field cannot be empty");
                    } else if (passwordController.text.length < 7) {
                      Toast().errorMessage(
                          "password length should be more than 8 characters");
                    } else if (!emailController.text.contains("@")) {
                      Toast().errorMessage("Not a valid email address");
                    } else {
                      Get.to(DisplayEventsScreen());
                    }
                  },
                  child: Container(
                    width: Get.width,
                    height: Get.height * 0.07,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                        child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Color(0xffff5085),
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    )),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ",
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            letterSpacing: 1.1,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        )),
                    InkWell(
                      onTap: () {
                        Get.to(const LoginScreen());
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            wordSpacing: 1.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
