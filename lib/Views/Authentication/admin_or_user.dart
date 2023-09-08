import 'package:eventflow/Views/Authentication/Login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminOrUserScreen extends StatelessWidget {
  const AdminOrUserScreen({super.key});

  final bool admin = true;
  final bool user = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding:
                EdgeInsets.only(left: Get.width * 0.2, right: Get.width * 0.2),
            height: Get.height,
            color: const Color(0xff151924),
            child: Container(
              margin: EdgeInsets.only(bottom: Get.height * 0.1),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                      height: Get.height * 0.02,
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
                      height: Get.height * 0.02,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: const BorderSide(color: Colors.red)), backgroundColor: Colors.blueAccent,
                            minimumSize: Size(Get.width, 45),
                            textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500) // Background color
                            ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return const LoginScreen(isAdmin: true,);
                          }));
                        },
                        child: const Text(
                          "Login as Admin",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: const BorderSide(color: Colors.red)), backgroundColor: Colors.redAccent,
                            minimumSize: Size(Get.width, 45),
                            textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500) // Background color
                            ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return const LoginScreen(isUser: true,);
                          }));
                        },
                        child: const Text(
                          "Login as User",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
