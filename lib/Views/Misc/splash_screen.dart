import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: Get.height * 0.2),
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/main-logo.png"),
              SizedBox(
                height: 40,
                child: Text(
                  "EventFlow",
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                        fontSize: 32,
                        color: Colors.red,
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
    );
  }
}
