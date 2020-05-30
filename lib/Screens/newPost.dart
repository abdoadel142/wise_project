import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:wise/classes/progress.dart';
import 'home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wise/Models/userData.dart';
import 'package:wise/Wservices/auth_services.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wise/Wservices/auth_services.dart';

class newPost extends StatefulWidget {
  static final id = 'newPost';

  @override
  _newPostState createState() => _newPostState();
}

class _newPostState extends State<newPost> {
  TextEditingController _textEditingController = TextEditingController();
  userData currentuser;
  FirebaseAuth _auth;
  File file;
  String postid = Uuid().v4();
  bool isUploading = false;
  String mediaUrl;
  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    try {
      currentuser = await authServices().Currentuser();
    } catch (e) {
      print(e);
      print('ddddd');
    }
  }

  handleTakePhoto() async {
    File file = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      this.file = file;
      print(file);
    });
  }

  handleChooseFromGallery() async {
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      this.file = file;
      // this.mediaUrl = mediaUrl;
      print(file);
    });
  }

  var data = [
    'Sports',
    'Eduction',
    'Culture',
    'Food',
    'Science',
    'Travel',
    'Work issues',
    'free time',
    'Music',
    'Movies',
    'Books',
    'Travel',
    'Hobbies',
    'Childern',
    'Pets',
    'Humor',
    'Sexual assault',
    'College Life',
    'Family Problems'
  ];
  var selected = [];
  String randomImage = 'https://picsum.photos/200/300';
  String _post;
  DateTime _dateTime;
  clearImage() {
    setState(() {
      file = null;
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postid.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask =
        storageRef.child("post_$postid.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  List<String> toList() {
    var newtuete;
    selected.forEach((item) {
      newtuete.add(item.toString());
    });

    return newtuete.toList();
  }

  createPostInFirestore({String mediaUrl, String postcontent}) {
    postsRef
        .document(currentuser.id)
        .collection("userPosts")
        .document(postid)
        .setData({
      "postId": postid,
      "ownerId": currentuser.id,
      "username": currentuser.name,
      "mediaUrl": mediaUrl,
      "timestamp": timestamp,
      "likes": {},
      "postcontent": postcontent,
      "topics": selected.join('  #'),
      "top": selected,
    });
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    if (file == null) {
      createPostInFirestore(
        mediaUrl: '',
        postcontent: _textEditingController.text,
      );
      Navigator.pop(context);
      setState(() {
        _textEditingController.clear();

        file = null;
        isUploading = false;
        postid = Uuid().v4();
      });
    } else {
      await compressImage();
      String mediaUrl = await uploadImage(file);

      createPostInFirestore(
        mediaUrl: mediaUrl,
        postcontent: _textEditingController.text,
      );
      Navigator.pop(context);
      setState(() {
        _textEditingController.clear();

        file = null;
        isUploading = false;
        postid = Uuid().v4();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.black,
        title: Text('New Question'),
        actions: <Widget>[
          MaterialButton(
            onPressed: handleSubmit,
            child: Text(
              'Post',
              style: TextStyle(
                  //color: Colors.white,
                  fontSize: 20),
            ),
          )
        ],
      ),
      body: isUploading
          ? linearProgress()
          : Container(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              currentUser.mediaUrl == null
                                  ? CircleAvatar(
                                      backgroundColor: Colors.grey,
                                    )
                                  : CircleAvatar(
                                      radius: 15,
                                      backgroundImage:
                                          NetworkImage(currentUser.mediaUrl),
                                    ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                currentUser.name,
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                          TextFormField(
                            controller: _textEditingController,
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              hintText: 'Ask new question',
                            ),
                          ),
                          file != null
                              ? Container(
                                  padding: EdgeInsets.all(10),
                                  height: 300,
                                  child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(file),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Divider(),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 15,
                            ),
                            child: Text(
                              'Which topics this question relate to ',
                              style: TextStyle(
                                fontSize: 20,
                                //    color: Colors.grey
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            child: ListView.builder(
                              itemCount: data.length,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.all(10),
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 3, left: 3),
                                  child: chooise_chips(context, index),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        child: ButtonBar(
                          alignment: MainAxisAlignment.start,
                          children: <Widget>[
                            MaterialButton(
                              child: Icon(Icons.picture_as_pdf),
                              onPressed: handleChooseFromGallery,
                            ),
                            MaterialButton(
                              child: Icon(Icons.camera_alt),
                              onPressed: handleTakePhoto,
                            ),
                            IconButton(
                              icon: Icon(Icons.tag_faces),
                              onPressed: () {
                                print(file);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget chooise_chips(BuildContext Context, int index) {
    return FilterChip(
      label: Text(data[index]),
      onSelected: (bool value) {
        if (selected.contains(data[index])) {
          selected.remove(data[index]);
        } else {
          selected.add(data[index]);
        }
        setState(() {});
      },
      selected: selected.contains(data[index]),
      selectedColor: Colors.grey[900],
      labelStyle: TextStyle(
        color: Colors.white,
      ),
      backgroundColor: Colors.grey,
      checkmarkColor: Colors.white,
    );
  }
}
