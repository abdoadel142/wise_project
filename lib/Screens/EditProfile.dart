import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:wise/Models/userData.dart';
import 'package:wise/Screens/Login_Screen.dart';
import 'package:wise/Screens/home_screen.dart';
import 'package:wise/Screens/profile_screen.dart';
import 'package:wise/Wservices/auth_services.dart';
import 'package:wise/classes/progress.dart';
import 'package:image/image.dart' as Im;

class EditProfile extends StatefulWidget {
  final String currentUserId;

  EditProfile({this.currentUserId});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  userData user;
  bool _displayNameValid = true;
  bool _bioValid = true;
  String photoid = Uuid().v4();
  String mediaUrl;
  File file;
  String Photoheader;
  bool isphoto = false;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  handleChooseFromGallery() async {
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
      print(file);
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$photoid.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask =
        storageRef.child("photo$photoid.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc =
        await authServices().userColection.document(widget.currentUserId).get();
    user = userData.FromDocument(doc);
    displayNameController.text = user.name;
    bioController.text = user.bio;
    Photoheader = user.mediaUrl;

    setState(() {
      if (Photoheader != null) {
        isphoto = true;
        isLoading = false;
      }
      isLoading = false;
    });
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Display Name",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: "Update Display Name",
            errorText: _displayNameValid ? null : "Display Name too short",
          ),
        )
      ],
    );
  }

  Column buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Bio",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: "Update Bio",
            errorText: _bioValid ? null : "Bio too long",
          ),
        )
      ],
    );
  }

  updateProfileData() async {
    setState(() {
      displayNameController.text.trim().length < 3 ||
              displayNameController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;
      bioController.text.trim().length > 100
          ? _bioValid = false
          : _bioValid = true;
    });
    bool k = false;
    if (_displayNameValid && _bioValid) {
      if (file != null) {
        await compressImage();
        String mediaUrl = await uploadImage(file);
        authServices().userColection.document(widget.currentUserId).updateData({
          "name": displayNameController.text,
          "bio": bioController.text,
          "mediaUrl": mediaUrl
        });
      } else {
        authServices().userColection.document(widget.currentUserId).updateData({
          "name": displayNameController.text,
          "bio": bioController.text,
        });
      }

      SnackBar snackbar = SnackBar(content: Text("Profile updated!"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
      setState(() {
        file = null;
        photoid = Uuid().v4();
      });
    }
  }

  logout() async {
    await authServices().signOut();
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, Login_Screen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Edit Profile",
        ),
        leading: IconButton(
          onPressed: () {
            setState(() {
              file = null;
              photoid = Uuid().v4();
            });
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: 30.0,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.done,
              size: 30.0,
            ),
          ),
        ],
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: handleChooseFromGallery,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                top: 16.0,
                                bottom: 8.0,
                              ),
                              child: isphoto == true
                                  ? CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              Photoheader),
                                    )
                                  : CircleAvatar(
                                      radius: 30.0,
                                      //               backgroundColor: Colors.grey,
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Edit Photo",
                                style: TextStyle(fontSize: 20),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            buildDisplayNameField(),
                            buildBioField(),
                          ],
                        ),
                      ),
                      RaisedButton(
                        //color: ThemeData.dark().primaryColorDark,
                        shape: StadiumBorder(),
                        onPressed: updateProfileData,
                        child: Text(
                          "Update Profile",
                          style: TextStyle(
                            fontSize: 20.0,
                            //  fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: FlatButton.icon(
                          shape: StadiumBorder(),
                          icon: Icon(Icons.clear),
                          // color: Colors.black,
                          onPressed: logout,
                          //  icon: Icon(Icons.cancel, color: Colors.red),
                          label: Text(
                            "Logout",
                            //    style: TextStyle(color: Colors.red, fontSize: 20.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
