import 'package:fart_magzine/home_page/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fart_magzine/signin_activities/login.dart';
import 'package:flutter/material.dart';
import 'package:fart_magzine/login_check_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  bool x = await login_credentials().login_status();
  runApp(myapp(
    login_status: x == null ? false : x,
  ));
}

class myapp extends StatefulWidget {
  bool login_status = false;
  myapp({this.login_status}) {}
  @override
  _myappState createState() => _myappState();
}

class _myappState extends State<myapp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: widget.login_status ? home_page() : login_page(),
    );
  }
}
