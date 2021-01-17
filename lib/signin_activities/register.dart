import 'dart:io';
import 'package:fart_magzine/home_page/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fart_magzine/login_check_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class register extends StatefulWidget {
  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  String password;
  var firestore = FirebaseFirestore.instance;

  File _image;
  String name;
  String address;
  bool name_status = false;
  bool address_status = false;
  bool password_status = false;
  final picker = ImagePicker();
  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(
        content: Row(
      children: [
        Expanded(
            child: IconButton(
          icon: Icon(Icons.add_a_photo),
          onPressed: () async {
            await getImage(ImageSource.camera);
          },
        )),
        Expanded(
            child: IconButton(
          icon: Icon(Icons.image),
          onPressed: () {},
        )),
      ],
    ));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future getImage(ImageSource source_) async {
    final pickedFile = await picker.getImage(source: source_);

    if (pickedFile != null) {
      File croppedfile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Profile Image',
            toolbarColor: Colors.blueAccent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
      );
      setState(() {
        _image = croppedfile;
      });
    } else {
      print('No image selected.');
    }
  }

  Future upload_image_and_url(BuildContext context, File image) async {
    var img_name = await login_credentials().getdata();
    var firebasestorage =
        FirebaseStorage.instance.ref('profile_pics').child(img_name);
    var b = await firebasestorage.putFile(image);
    var ur = await firebasestorage.getDownloadURL();
    try {
      await firestore.collection('/users').doc(img_name).set({
        'imageurl': ur,
        'name': name,
        'address': address,
        'password': password
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register New User"),
      ),
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    _displaySnackBar(context);
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * .2,
                    // width: MediaQuery.of(context).size.width * .4,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.5, color: Colors.blueGrey),
                        image: _image == null
                            ? null
                            : DecorationImage(
                                image: FileImage(_image), fit: BoxFit.fill),
                        shape: BoxShape.circle),
                    child: Center(
                      child: _image == null
                          ? Icon(
                              Icons.person_add,
                              size: MediaQuery.of(context).size.height * .1,
                            )
                          : null,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * .15,
                    right: MediaQuery.of(context).size.width * .15,
                  ),
                  child: TextField(
                    onChanged: (e) {
                      name = e;
                      if (name_status) {
                        setState(() {
                          name_status = false;
                        });
                      }
                    },
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        hintText: "Enter Name",
                        errorText: name_status ? "Enter Name" : null),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * .15,
                      right: MediaQuery.of(context).size.width * .15,
                      top: 25),
                  child: TextField(
                    onChanged: (e) {
                      address = e;
                      if (address_status) {
                        setState(() {
                          address_status = false;
                        });
                      }
                    },
                    maxLines: null,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        hintText: "Enter Address",
                        errorText: name_status ? "Enter address" : null),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * .15,
                      right: MediaQuery.of(context).size.width * .15,
                      top: 25),
                  child: TextField(
                    onChanged: (e) {
                      password = e;
                      if (password_status) {
                        setState(() {
                          password_status = false;
                        });
                      }
                    },
                    textAlign: TextAlign.center,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Enter Password",
                        errorText: name_status ? "Enter Password" : null),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                InkWell(
                  onTap: () async {
                    if (name == "" || name == null) {
                      setState(() {
                        name_status = true;
                      });
                    }
                    if (address == "" || address == null) {
                      setState(() {
                        address_status = true;
                      });
                    }
                    if (password == "" || password == null) {
                      setState(() {
                        password_status = true;
                      });
                    }
                    if (name.length > 0 &&
                        address.length > 0 &&
                        password.length > 0) {
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            scrollable: true,
                            title: Text("Signing you up"),
                            content: Center(child: CircularProgressIndicator()),
                          ));
                      await upload_image_and_url(context, _image);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => home_page()));
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * .8,
                    height: 25,
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
