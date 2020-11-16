import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_login/screens/home.dart';
import 'package:firebase_login/screens/login/login.dart';
import 'package:firebase_login/utils/create_material_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences sharedPreferences;
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    _getInitData();
  }

  void _getInitData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isLogin = sharedPreferences.getBool('isLogin') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Login',
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color(0xff077F7B)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isLogin ? Home() : Login(),
    );
  }
}
