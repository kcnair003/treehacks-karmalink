import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraAlert extends StatefulWidget {
  CameraAlert({Key key}) : super(key: key);

  @override
  _CameraAlertState createState() => _CameraAlertState();
}

class _CameraAlertState extends State<CameraAlert> {
  File _image;
  var uid;

  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  /// TODO: Migrate
  Future uploadFile() async {
    // StorageReference storageReference = FirebaseStorage.instance
    //     .ref()
    //     .child('profile_pictures/$_image');
    // StorageUploadTask uploadTask = storageReference.putFile(_image);
    // await uploadTask.onComplete;
  }

  Widget _optionsDialogBox(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            GestureDetector(
              child: Text('Take a picture'),
              onTap: () => getImage(ImageSource.camera),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            GestureDetector(
              child: Text('Select from gallery'),
              onTap: () => getImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _optionsDialogBox(context);
  }
}
