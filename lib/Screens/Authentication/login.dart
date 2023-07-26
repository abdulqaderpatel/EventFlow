import 'package:eventflow/Reusable_Components/Authentication/auth_button.dart';
import 'package:eventflow/Screens/Authentication/signup.dart';
import 'package:eventflow/Screens/Misc/toast/toast.dart';
import 'package:eventflow/Screens/User/display_events.dart';
import 'package:eventflow/Screens/User/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
          padding: EdgeInsets.only(
            left: Get.width * 0.1,
            right: Get.width * 0.1,
            top: MediaQuery
                .of(context)
                .size
                .height * 0.07,
            bottom: MediaQuery
                .of(context)
                .size
                .height * 0.07,
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
                Container(
                  height: Get.height * 0.17,
                  width: Get.height * 0.17,
                  decoration: BoxDecoration(
                      color: const Color(
                        0xffff8c85,
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
                AuthButton("Email", Icons.email, emailController, false),
                SizedBox(height: Get.height * 0.03),
                AuthButton("Password", Icons.key, passwordController, true),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () async{
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text);
                      Get.to(Navigation());
                      Toast().successMessage("Logged in successfully");
                    }
                    on FirebaseAuthException catch(e)
                    {
                    if(e.code=="invalid-email")
                    {
                    Toast().errorMessage("Invalid email entered");
                    }
                    else  if(e.code=="user-not-found")
                    {
                    Toast().errorMessage("No user found with the corresponding email");
                    }
                     else if(e.code=="wrong-password")
                        {
                          Toast().errorMessage("Wrong password entered");
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
                    child: const Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
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
                        color: Colors.red,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Or",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.red,
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
                      onTap: () => Get.to(const SignupScreen()),
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
