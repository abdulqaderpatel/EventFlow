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

  final _formKey = GlobalKey<FormState>();

  Future registerWithEmailAndPassword(
      String name, String password, String email) async {
    UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = result.user;
    user!.updateDisplayName(nameController.text); //added this line
    return user;
  }

  late List<Map<String, dynamic>> users;
  late List<Map<String, dynamic>> admins;
  static final nameRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
  static final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  Future<bool> checkIfAdminLoggingIntoUser(String email) async {
    users = [];
    var userData =
        await FirebaseTable().usersTable.where('email', isEqualTo: email).get();

    List<Map<String, dynamic>> userTemp = [];

    userData.docs.forEach((element) {
      setState(() {
        userTemp.add(element.data());
      });
    });

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

    adminData.docs.forEach((element) {
      setState(() {
        adminTemp.add(element.data());
      });
    });

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
                Row(
                  children: [
                    Container(
                      height: Get.height * 0.1,
                      width: Get.height * 0.1,
                      decoration: BoxDecoration(
                          color: Color(
                            widget.isAdmin == true ? 0xff6495ED : 0xffff8c85,
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
                    color:
                        Color(widget.isAdmin == true ? 0xff6495ED : 0xffff8a84),
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
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: Get.height * 0.05,
                      ),
                      AuthButton(
                        name: "Name",
                        icon: Icons.person,
                        controller: nameController,
                        obscureText: false,
                        isAdmin: widget.isAdmin == true ? true : false,
                        validator: (value) {
                          print(value);
                          if (value == null||value.isEmpty||!RegExp(r"^[\p{L} ,.'-]*$",
                              caseSensitive: false, unicode: true, dotAll: true)
                              .hasMatch(value)) {
                            Toast().errorMessage("Invalid name");
                          return "";
                          }

                            return null;

                        },
                      ),
                      SizedBox(height: Get.height * 0.03),
                      AuthButton(
                        name: "Email",
                        icon: Icons.email,
                        controller: emailController,
                        obscureText: false,
                        isAdmin: widget.isAdmin == true ? true : false,
                        validator: (value) {
                          print(value);
                          if (value == null||value.isEmpty||!emailRegExp.hasMatch(value)) {
                            Toast().errorMessage("Invalid email");
                            return "";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: Get.height * 0.03),
                      AuthButton(
                        name: "Password",
                        icon: Icons.key,
                        controller: passwordController,
                        obscureText: true,
                        isAdmin: widget.isAdmin == true ? true : false,
                        validator: (value) {
                          if (value == null||value.isEmpty) {
                            return "password field cannot be empty";
                          }

                          return null;
                        },
                      ),
                      SizedBox(height: Get.height * 0.05),
                      InkWell(
                        onTap: () async {
                          print(_formKey.currentState!.validate());
                          if (!_formKey.currentState!.validate()) {
                            print("error");
                            return;
                          } else {
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
                                await registerWithEmailAndPassword(
                                    nameController.text,
                                    passwordController.text,
                                    emailController.text);

                                if (widget.isAdmin == true) {
                                  Get.to(AdminNavigationBar());
                                  await FirebaseTable()
                                      .adminsTable
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .set({
                                    "email": FirebaseAuth
                                        .instance.currentUser!.email,
                                    "username": "",
                                    "name": nameController.text,
                                    "image": "",
                                    "phone_number": 0
                                  });
                                } else {
                                  Get.to(UserNavigationBar());
                                  await FirebaseTable()
                                      .usersTable
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .set({
                                    "email": FirebaseAuth
                                        .instance.currentUser!.email,
                                    "username": "",
                                    "name": nameController.text,
                                    "image": "",
                                    "phone_number": 0
                                  });
                                }
                                Toast().successMessage(
                                    "Account created successfully");
                              } on FirebaseAuthException catch (e) {
                                if (e.code == "email-already-in-use") {
                                  Toast().errorMessage(
                                      "The email is already in use");
                                } else if (e.code == "invalid-email") {
                                  Toast().errorMessage(
                                      "The email entered is invalid");
                                } else if (e.code == "weak-password") {
                                  Toast().errorMessage("Weak password entered");
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
                                ? "Sign Up as Admin"
                                : "Sign up as User",
                            style: const TextStyle(
                                color: Color(0xffff5085),
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          )),
                        ),
                      ),
                    ],
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
                        Get.to(widget.isAdmin == true
                            ? LoginScreen(
                                isAdmin: true,
                              )
                            : LoginScreen(
                                isUser: true,
                              ));
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
