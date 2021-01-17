import 'package:fart_magzine/login_check_bloc.dart';
import 'package:fart_magzine/signin_activities/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:sms_autofill/sms_autofill.dart';

class otp_page extends StatefulWidget {
  String mobile;
  otp_page({this.mobile}) {}
  @override
  _otp_pageState createState() => _otp_pageState();
}

class _otp_pageState extends State<otp_page> {
  String otp;
  // final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode;
  final TextEditingController _pinputcontroller = TextEditingController();
  final BoxDecoration pinputdecoration = BoxDecoration(
    border: Border.all(
      color: Colors.blueAccent,
      width: 5,
    ),
    borderRadius: BorderRadius.circular(10.0),
    color: Colors.blueAccent,
  );
  final FocusNode _pinputfocusnode = FocusNode();

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.mobile,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => register()));
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  @override
  void initState() {
    // TODO: implement initState
    _verifyPhone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height * .1),
              child: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                radius: MediaQuery.of(context).size.height * .1,
                child: Icon(
                  Icons.call,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.height * .1,
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height * .1),
              child: Container(
                //width: MediaQuery.of(context).size.width * .6,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * .1,
                      right: MediaQuery.of(context).size.width * .1),
                  // child: TextField(
                  //   //ONchange number save here
                  //   onSubmitted: (t) {
                  //     // ################## on changed grab otp from here
                  //   },
                  //   decoration: InputDecoration(
                  //     icon: Icon(Icons.message),
                  //     hintText: 'Enter OTP',
                  //     focusedBorder: UnderlineInputBorder(
                  //       borderSide: BorderSide(color: Colors.teal[300]),
                  //     ),
                  //   ),
                  // ),
                  child: PinPut(
                    fieldsCount: 6,
                    textStyle:
                        const TextStyle(fontSize: 25.0, color: Colors.white),
                    eachFieldWidth: 40.0,
                    eachFieldHeight: 55.0,
                    focusNode: _pinputfocusnode,
                    controller: _pinputcontroller,
                    submittedFieldDecoration: pinputdecoration,
                    selectedFieldDecoration: pinputdecoration,
                    followingFieldDecoration: pinputdecoration,
                    pinAnimationType: PinAnimationType.fade,
                    onSubmit: (pin) async {
                      otp = pin;
                      try {
                        var x = await FirebaseAuth.instance
                            .signInWithCredential(PhoneAuthProvider.credential(
                                verificationId: _verificationCode,
                                smsCode: pin))
                            .then((value) async {
                          if (value.user != null) {
                            await login_credentials()
                                .login(phone: widget.mobile);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        register()));
                          }
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .1,
                left: MediaQuery.of(context).size.width * .09,
                right: MediaQuery.of(context).size.width * .09,
              ),
              child: GestureDetector(
                onTap: () async {
                  try {
                    await FirebaseAuth.instance
                        .signInWithCredential(PhoneAuthProvider.credential(
                            verificationId: _verificationCode, smsCode: otp))
                        .then((value) async {
                      if (value.user != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => register()));
                      }
                    });
                  } catch (e) {
                    print(e);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * .1,
                  child: Center(
                    child: Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
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
