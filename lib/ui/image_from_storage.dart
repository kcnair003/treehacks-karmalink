import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

class ImageFromStorage extends StatefulWidget {
  /// TODO: Migrate
  ImageFromStorage({this.image});

  // Name of the image file (e.g., dog.jpg)
  final String image;

  @override
  _ImageFromStorageState createState() => _ImageFromStorageState();
}

class _ImageFromStorageState extends State<ImageFromStorage> {
  // StorageReference storageRef = FirebaseStorage(
  //   storageBucket: 'gs://hesprmvp-vcm',
  // ).ref();
  FirebaseStorage storageRef = FirebaseStorage.instance;
  Uint8List imageFile;

  /// TODO: Migrate
  getImage() {
    const int maxSize = 10 * 1024 * 1024; // 10 MB

    // storageRef
    //     .child(widget.image)
    //     .getData(maxSize)
    //     .then((data) {
    //   this.setState(() {
    //     imageFile = data;
    //   });
    // }).catchError((error) {
    //   return;
    // });
  }

  Widget decideImage() {
    if (imageFile == null) {
      //! Check if I need this
      return Center(
        child: SizedBox(
          //! Check this
          width: 30,
          height: 30,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      return Image.memory(imageFile, fit: BoxFit.fitHeight);
    }
  }

  @override
  initState() {
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return decideImage();
  }
}
