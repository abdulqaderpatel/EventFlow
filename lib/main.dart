import 'package:eventflow/Views/Admin/Profile/create_admin_profile.dart';
import 'package:eventflow/Views/Admin/admin_navigation_bar.dart';
import 'package:eventflow/Views/Authentication/admin_or_user.dart';
import 'package:eventflow/Views/Misc/Firebase/firebase_tables.dart';
import 'package:eventflow/Views/Misc/SplashScreen.dart';
import 'package:eventflow/Views/User/Profile/create_user_profile.dart';
import 'package:eventflow/Views/User/user_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final user = FirebaseAuth.instance.currentUser;
  final userEmail = FirebaseAuth.instance.currentUser?.email;

  List<Map<String, dynamic>> items = [];

  bool isLoaded = false;

  late List<Map<String, dynamic>> loggedInUser = [];
  late List<Map<String, dynamic>> loggedInAdmin = [];

  void incrementCounter() async {
    late List<Map<String, dynamic>> userTemp = [];
    late List<Map<String, dynamic>> adminTemp = [];
    var userData = await FirebaseTable()
        .usersTable
        .where("email", isEqualTo: userEmail)
        .get();
    var adminData = await FirebaseTable()
        .adminsTable
        .where("email", isEqualTo: userEmail)
        .get();

    for (var element in userData.docs) {
      setState(() {
        userTemp.add(element.data());
      });
    }

    for (var element in adminData.docs) {
      setState(() {
        adminTemp.add(element.data());
      });
    }

    setState(() {
      loggedInUser = userTemp;
      loggedInAdmin = adminTemp;
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    incrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: isLoaded
            ? user == null
                ? AdminOrUserScreen()
                : loggedInUser.isNotEmpty
                    ? (loggedInUser[0]["username"] == ""
                        ? CreateUserProfileScreen()
                        : UserNavigationBar())
                    : loggedInAdmin[0]["username"] == ""
                        ? CreateAdminProfileScreen()
                        : AdminNavigationBar()
            : SplashScreen());
  }
}
