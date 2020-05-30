import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class testhome extends StatefulWidget {
  static const id = "home";

  @override
  _testhomeState createState() => _testhomeState();
}

class _testhomeState extends State<testhome> {
  Future<File> imageFile;

  pickImageFromGallery(ImageSource source) {
    setState(() {});
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: FileImage(snapshot.data), fit: BoxFit.cover),
            ),
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return Container(
            height: 0,
            width: 0,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        showImage(),
        Center(
          child: MaterialButton(
            child: Text('pick'),
            onPressed: pickImageFromGallery(ImageSource.gallery),
          ),
        ),
      ],
    ));
  }
}
