import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color:const Color(0xff151924),
        child: Container(height: Get.height,
          margin: EdgeInsets.only(bottom: Get.height * 0.1),

          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
