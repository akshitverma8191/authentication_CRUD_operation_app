import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fart_magzine/home_page/home.dart';
import 'package:fart_magzine/login_check_bloc.dart';
import 'package:fart_magzine/signin_activities/otp_pages.dart/phone_verification.dart';
import 'package:flutter/material.dart';

class login_page extends StatefulWidget {
  @override
  _login_pageState createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  String phone;
  String password;

  Future login() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var result = await firestore.collection('/users').get();
    for (var data in result.docs) {
      if (data.id == phone) {
        if (data.data()['password'] == password) {
          var local = login_credentials();
          await local.login(phone: phone);

          //Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => home_page()));
          break;
        }
      } else {
        // Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Fart Magzine Task")),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .15,
            ),
            Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "LOGIN",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    onChanged: (e) {
                      phone = e;
                    },
                    decoration:
                        InputDecoration(hintText: "Enter mobile Number +91.."),
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    onChanged: (e) {
                      password = e;
                    },
                    obscureText: true,
                    decoration: InputDecoration(hintText: "Enter Password"),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.login,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () async {
                        // showDialog(
                        //     context: context,
                        //     child: AlertDialog(
                        //       scrollable: true,
                        //       title: Text("Logging in"),
                        //       content:
                        //           Center(child: CircularProgressIndicator()),
                        //     ));
                        await login();
                        //  Navigator.pop(context);
                      })
                ],
              ),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(20)),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => enter_number()));
              },
              child: Container(
                margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                width: MediaQuery.of(context).size.width,
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.blueAccent),
                child: Center(
                  child: Text(
                    "Register New User",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
