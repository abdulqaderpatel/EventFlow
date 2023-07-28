import 'package:eventflow/Reusable_Components/Authentication/auth_button.dart';
import 'package:eventflow/Views/Admin/admin_navigation_bar.dart';
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:eventflow/Views/Misc/toast/toast.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../User/user_navigation_bar.dart';
import 'Login.dart';

class SignupScreen extends StatefulWidget {
  final bool? isAdmin;
  final bool? isUser;

  const SignupScreen({super.key, this.isAdmin = false, this.isUser = false});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  Future registerWithEmailAndPassword(
      String name, String password, String email) async {
    UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = result.user;
    user!.updateProfile(displayName: name); //added this line
    return user;
  }


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
          height: Get.height,
          padding: EdgeInsets.only(
            left: Get.width * 0.1,
            right: Get.width * 0.1,
            top: MediaQuery.of(context).size.height * 0.07,
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
                  width: Get.width * 0.34,
                  height: Get.height * 0.17,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color(0xffff8a84),
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
                  onTap: () async {

                      try {
                        registerWithEmailAndPassword(nameController.text,
                            passwordController.text, emailController.text);

                        if (widget.isAdmin == true) {
                          Get.to(AdminNavigationBar());
                          await FirebaseTable()
                              .adminsTable
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .set({
                            "email": FirebaseAuth.instance.currentUser!.email,
                            "username": "",
                            "name": nameController.text,
                            "image": "",
                            "phone_number": 0
                          });
                        } else {
                          Get.to(UserNavigationBar());
                          await FirebaseTable()
                              .usersTable
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .set({
                            "email": FirebaseAuth.instance.currentUser!.email,
                            "username": "",
                            "name": nameController.text,
                            "image": "",
                            "phone_number": 0
                          });
                        }
                        Toast().successMessage("Account created successfully");
                      } on FirebaseAuthException catch (e) {
                        if (e.code == "email-already-in-use") {
                          Toast().errorMessage("The email is already in use");
                        } else if (e.code == "invalid-email") {
                          Toast().errorMessage("The email entered is invalid");
                        } else if (e.code == "weak-password") {
                          Toast().errorMessage("Weak password entered");
                        }
                      }

                  },
                  child: Container(
                    width: Get.width,
                    height: Get.height * 0.07,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                        child: Text(
                      widget.isAdmin == true
                          ? "Sign Up as Admin"
                          : "Sign up as User",
                      style: const TextStyle(
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
