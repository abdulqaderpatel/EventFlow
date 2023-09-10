
import 'package:eventflow/Views/Authentication/Login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminOrUserScreen extends StatefulWidget {
  const AdminOrUserScreen({super.key});

  @override
  State<AdminOrUserScreen> createState() => _AdminOrUserScreenState();
}

class _AdminOrUserScreenState extends State<AdminOrUserScreen> with TickerProviderStateMixin {
  final bool admin = true;

  final bool user = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topRight,
            end: Alignment.bottomRight,
            colors: [
              Colors.redAccent,
              Colors.purple,
              Colors.blueAccent
            ],
          )),
            padding:
                EdgeInsets.only(left: Get.width * 0.15, right: Get.width * 0.15),
            height: Get.height,

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
                    InkWell(onTap: (){
                      Get.to(const LoginScreen(isAdmin: true,));
                    },
                      child: Container(
                        height: 45,width: Get.width*0.8, // min sizes for Material buttons
                        alignment: Alignment.center,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),gradient:const LinearGradient(colors: [
                          Color(0xffF907FC),
                          Color(0xff05D6D9)
                        ]), ),
                        child: const Text(
                          'Login as Admin',
                          textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    InkWell(onTap: (){
            Get.to(const LoginScreen(isUser:true));
                    },
                      child: Container(
                        height: 45,width: Get.width*0.8, // min sizes for Material buttons
                        alignment: Alignment.center,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),gradient:const LinearGradient(colors: [
                          Color(0xffFF0000),
                          Color(0xffFF7878)
                        ]), ),
                        child: const Text(
                          'Login as User',
                          textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
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
