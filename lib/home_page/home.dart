import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fart_magzine/login_check_bloc.dart';
import 'package:fart_magzine/signin_activities/login.dart';
import 'package:flutter/material.dart';

class home_page extends StatefulWidget {
  @override
  _home_pageState createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  List<Widget> rows;
  var firestore = FirebaseFirestore.instance;
  Future get_data() async {
    rows = [];
    var results = await firestore.collection("/users").get();
    var subs = await firestore.collection("/users").snapshots();
    for (var data in results.docs) {
      print(data.id);
      var map = data.data();
      setState(() {
        rows.add(Padding(
          padding: EdgeInsets.all(25),
          child: Row(
            children: [
              Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(data.data()["imageurl"]),
                        fit: BoxFit.fill)),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                data.data()["name"],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                width: 10,
              ),
              Text(data.data()["address"])
            ],
          ),
        ));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          InkWell(
              onTap: () async {
                await login_credentials().logout();
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => login_page()));
              },
              child: Text("Logout"))
        ],
      ),
      body: rows == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(children: rows),
    );
  }
}
