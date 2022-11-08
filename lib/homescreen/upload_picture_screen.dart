import 'dart:io';

import 'package:docudi/firebase_api.dart';
import 'package:docudi/homescreen/homescreen.dart.dart';
import 'package:docudi/provider/dataProvider.dart';
import 'package:docudi/provider/user.dart';
import 'package:docudi/user_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class UploadPictureScreen extends StatefulWidget {
  static const routeName = "/upload-picture";

  @override
  State<UploadPictureScreen> createState() => _UploadPictureScreenState();
}

class _UploadPictureScreenState extends State<UploadPictureScreen> {
  File? file;
  UploadTask? task;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() {
      file = File(path);
    });
  }

  Future uploadFile(BuildContext context) async {
    if (file == null) return;
    final fileName = basename(file!.path);
    final destination = "/files/$fileName";
    task = FirebaseApi.uploadFile(destination, file!);
    if (task == null) return;
    final snapshot = await task!.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    Provider.of<User>(context, listen: false).updatePicture(urlDownload);
    await uploadPhoto(urlDownload, Provider.of<User>(context, listen: false).id.toString());
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          var c = MediaQuery.of(context).size.width;
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);
            return Center(
              child: Text(
                "$percentage %",
                style: TextStyle(fontFamily: "Poppins", color: Colors.black, fontSize: 0.04572 * c),
              ),
            );
          } else {
            return Container();
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : "No file selected";
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: Center(
                child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(141, 131, 252, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Icon(Icons.attachment, color: Colors.white),
                      ),
                      Text(
                        "Select profile photo",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () => {selectFile()},
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              child: Center(
                child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(141, 131, 252, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Icon(Icons.cloud_upload, color: Colors.white),
                      ),
                      Text(
                        "Upload file",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () => {uploadFile(context)},
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                child: Text(
                  fileName,
                  style: TextStyle(fontFamily: "Poppins", color: Colors.black, fontSize: 12),
                ),
              ),
            ),
            task != null ? buildUploadStatus(task!) : Container(),
          ],
        ),
      ),
    );
  }
}
