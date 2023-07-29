import 'package:eventflow/Views/Authentication/Login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AdminOrUserScreen extends StatelessWidget {
  const AdminOrUserScreen({super.key});

  final bool admin = true;
  final bool user = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [


        Expanded(
          child: InkWell(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context){
            return const LoginScreen(isAdmin: true,);
    }));},
            child: Container(
              color: Colors.blue,
              child: const Center(
                child: Text(
                  "Admin",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return LoginScreen(isUser: true,);
    }));
    },
            child: Container(
              color: Colors.red,
              child: const Center(
                child: Text(
                  "User",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
