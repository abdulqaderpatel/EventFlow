import 'package:eventflow/Reusable_Components/Authentication/auth_button.dart';
import 'package:eventflow/Views/Admin/Profile/create_admin_profile.dart';

import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:eventflow/Views/Misc/toast/toast.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../User/Profile/create_user_profile.dart';

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



  bool buttonLoader=false;

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
  static final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

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
                Column(
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
                        return null;
                      },
                    ),
                    SizedBox(height: Get.height * 0.05),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          buttonLoader=true;
                        });
                        if (nameController.text.isEmpty) {
                          Toast().errorMessage("Name cannot be empty");
                          setState(() {
                            buttonLoader=false;
                          });
                        } else if (emailController.text.isEmpty) {
                          Toast().errorMessage("Email cannot be empty");
                          setState(() {
                            buttonLoader=false;
                          });
                        } else if (passwordController.text.isEmpty) {
                          Toast().errorMessage("password cannot be empty");
                          setState(() {
                            buttonLoader=false;
                          });
                        }
                        else if(!RegExp(r'^[a-zA-Z0-9]+$')
                            .hasMatch(nameController.text))
                          {
                            Toast().errorMessage("Invalid name entered");
                            setState(() {
                              buttonLoader=false;
                            });
                          }
                        else if(!emailRegExp.hasMatch(emailController.text)){
                          Toast().errorMessage("Invalid email entered");
                          setState(() {
                            buttonLoader=false;
                          });
                        }
                        else if(passwordController.text.length<6)
                          {
                            Toast().errorMessage("Password length should be more than 6 characters");
                            setState(() {
                              buttonLoader=false;
                            });
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
                              setState(() {
                                buttonLoader=false;
                              });
                            } else {
                              Toast().errorMessage(
                                  "This email already exists as an admin");
                              setState(() {
                                buttonLoader=false;
                              });
                            }
                          } else {
                            try {
                              await registerWithEmailAndPassword(
                                  nameController.text,
                                  passwordController.text,
                                  emailController.text);

                              if (widget.isAdmin == true) {
                                setState(() {
                                  buttonLoader=false;
                                });
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const CreateAdminProfileScreen();
                                }));
                                await FirebaseTable()
                                    .adminsTable
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .set({
                                  "email":
                                      FirebaseAuth.instance.currentUser!.email,
                                  "username": "",
                                  "name": nameController.text,
                                  "image": "",
                                  "phone_number": 0,
                                  "id":FirebaseAuth.instance.currentUser!.uid,
                                });
                              } else {
                                setState(() {
                                  buttonLoader=false;
                                });
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const CreateUserProfileScreen();
                                }));
                                await FirebaseTable()
                                    .usersTable
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .set({
                                  "email":
                                      FirebaseAuth.instance.currentUser!.email,
                                  "username": "",
                                  "name": nameController.text,
                                  "image": "",
                                  "phone_number": 0,
                                  "id":FirebaseAuth.instance.currentUser!.uid,
                                  "follower":[],
                                  "following":[]
                                });
                              }
                              Toast().successMessage(
                                  "Account created successfully");
                              setState(() {
                                buttonLoader=false;
                              });
                            } on FirebaseAuthException catch (e) {
                              if (e.code == "email-already-in-use") {
                                Toast().errorMessage(
                                    "The email is already in use");
                                setState(() {
                                  buttonLoader=false;
                                });
                              } else if (e.code == "invalid-email") {
                                Toast().errorMessage(
                                    "The email entered is invalid");
                                setState(() {
                                  buttonLoader=false;
                                });
                              } else if (e.code == "weak-password") {
                                Toast().errorMessage("Weak password entered");
                                setState(() {
                                  buttonLoader=false;
                                });
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
                            child:buttonLoader==false? Text(
                          widget.isAdmin == true
                              ? "Sign Up as Admin"
                              : "Sign up as User",
                          style: const TextStyle(
                              color: Color(0xffff5085),
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ):const CircularProgressIndicator()),
                      ),
                    ),
                  ],
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
                        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                          return widget.isAdmin==true?const LoginScreen(isAdmin:true):const LoginScreen(isUser:true);
                        }),);

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
