import 'package:eventflow/Reusable_Components/Authentication/auth_button.dart';
import 'package:eventflow/Views/Admin/admin_navigation_bar.dart';
import 'package:eventflow/Views/Authentication/signup.dart';
import 'package:eventflow/Views/Misc/toast/toast.dart';

import 'package:eventflow/Views/User/user_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Misc/Firebase/firebase_tables.dart';

class LoginScreen extends StatefulWidget {
  final bool? isAdmin;
  final bool? isUser;

  const LoginScreen({super.key, this.isAdmin = false, this.isUser = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  late List<Map<String, dynamic>> users;
  late List<Map<String, dynamic>> admins;

  Future<bool> checkIfAdminLoggingIntoUser(String email) async {
    users = [];
    var userData =
        await FirebaseTable().usersTable.where('email', isEqualTo: email).get();

    List<Map<String, dynamic>> userTemp = [];

    for (var element in userData.docs) {
      setState(() {
        userTemp.add(element.data());
      });
    }

    setState(() {
      users = userTemp;
    });

    if (users.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> checkIfUserLoggingIntoAdmin(String email) async {
    admins = [];

    var adminData = await FirebaseTable()
        .adminsTable
        .where('email', isEqualTo: emailController.text)
        .get();

    List<Map<String, dynamic>> adminTemp = [];

    for (var element in adminData.docs) {
      setState(() {
        adminTemp.add(element.data());
      });
    }

    setState(() {
      admins = adminTemp;
    });

    if (admins.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  late bool adminOrUser;

  @override
  void dispose() {
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
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: widget.isAdmin == true
                      ? [
                          const Color(0xff6495ED),
                          const Color(0xff0047AB),
                          const Color(0xff1434A4),
                        ]
                      : [
                          const Color(0xffff8a78),
                          const Color(0xffff6b74),
                          const Color(0xffff3f6f),
                        ])),
          child: Center(
            child: Column(
              children: [
                Container(
                  height: Get.height * 0.17,
                  width: Get.height * 0.17,
                  decoration: BoxDecoration(
                      color: Color(
                        widget.isAdmin == true ? 0xff6495ED : 0xffff8c85,
                      ),
                      borderRadius: BorderRadius.circular(25)),
                  child: Image.asset(
                    "assets/images/main-logo.png",
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.04,
                ),
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
                SizedBox(
                  height: Get.height * 0.04,
                ),
                AuthButton(
                  name: "Email",
                  icon: Icons.email,
                  controller: emailController,
                  obscureText: false,
                  isAdmin: widget.isAdmin == true ? true : false,
                  validator: (value){

                  },
                ),
                SizedBox(height: Get.height * 0.03),
                AuthButton(
                    name: "Password",
                    icon: Icons.key,
                    controller: passwordController,
                    obscureText: true,
                    isAdmin: widget.isAdmin == true ? true : false,
                validator: (value){

                },),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () async {
                    if(emailController.text.isEmpty)
                      {
                        Toast().errorMessage("Email cannot be empty");
                      }
                    else if(passwordController.text.isEmpty)
                      {
                        Toast().errorMessage("Password cannot be empty");
                      }
                    else {
                      adminOrUser = widget.isAdmin == true
                          ? await checkIfAdminLoggingIntoUser(
                          emailController.text)
                          : await checkIfUserLoggingIntoAdmin(
                          emailController.text);
                      if (adminOrUser) {
                        if (widget.isAdmin == true) {
                          Toast().errorMessage(
                              "This email already exists as a user");
                        } else {
                          Toast().errorMessage(
                              "This email already exists as an admin");
                        }
                      } else {
                        try {
                          if (widget.isAdmin == true) {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                              return AdminNavigationBar();
                            }));
                          } else {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                              return UserNavigationBar();
                            }));
                          }
                          Toast().successMessage("Logged in successfully");
                        } on FirebaseAuthException catch (e) {
                          if (e.code == "invalid-email") {
                            Toast().errorMessage("Invalid email entered");
                          } else if (e.code == "user-not-found") {
                            Toast().errorMessage(
                                "No user found with the corresponding email");
                          } else if (e.code == "wrong-password") {
                            Toast().errorMessage("Wrong password entered");
                          }
                        }
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
                          ? "Login as Admin"
                          : "Login as User",
                      style: const TextStyle(
                          color: Color(0xffff5085),
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    )),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.04,
                ),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Or",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.04,
                ),
                InkWell(
                  child: Container(
                    width: Get.width,
                    height: Get.height * 0.07,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                        child: Row(
                      children: [
                        Image.asset("assets/images/google-logo.png"),
                        Container(
                          margin: EdgeInsets.only(left: Get.width * 0.1),
                          child: const Text(
                            "Sign In with Google",
                            style: TextStyle(
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ",
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            letterSpacing: 1.1,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        )),
                    InkWell(
                      onTap: () => Get.to(
                        SignupScreen(
                          isAdmin: widget.isAdmin,
                          isUser: widget.isUser,
                        ),
                      ),
                      child: const Text(
                        "Sign up now",
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
