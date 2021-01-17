import 'package:fart_magzine/signin_activities/otp_pages.dart/otp_page.dart';
import 'package:flutter/material.dart';

class enter_number extends StatefulWidget {
  @override
  _enter_numberState createState() => _enter_numberState();
}

class _enter_numberState extends State<enter_number> {
  String mobile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verfiy Mobile Number"),
      ),
      body: Builder(
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  onChanged: (e) {
                    mobile = e;
                  },
                  textAlign: TextAlign.center,
                  decoration:
                      InputDecoration(hintText: "Enter Mobile number,+91..."),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => otp_page(
                                mobile: mobile,
                              )));
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                  width: MediaQuery.of(context).size.width,
                  height: 25,
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(25)),
                  child: Center(
                    child: Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
