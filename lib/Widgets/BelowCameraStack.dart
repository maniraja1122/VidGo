import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialframe/Repository/DBHelper.dart';

class BelowCameraStack extends StatelessWidget {
  const BelowCameraStack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Align(
        alignment: Alignment.bottomRight,
        child: InkWell(
          onTap: () async {
            var picked = await ImagePicker().pickImage(
                source: ImageSource.gallery, maxHeight: 1800, maxWidth: 1800);
            if (picked != null) {
              File imgfile = File(picked.path);
              try {
                await DBHelper.storage
                    .ref()
                    .child("ProfilePics")
                    .child(DBHelper.auth.currentUser!.uid)
                    .putFile(imgfile);
                var newimgurl = await DBHelper.storage
                    .ref()
                    .child("ProfilePics")
                    .child(DBHelper.auth.currentUser!.uid)
                    .getDownloadURL();
                DBHelper.db.runTransaction((transaction) async {
                  var data = await DBHelper.db
                      .collection("Users")
                      .where("key", isEqualTo: DBHelper.auth.currentUser!.uid)
                      .get();
                  var currentsnap = data.docs[0].reference;
                  var securesnap = await transaction.get(currentsnap);
                  transaction
                      .update(securesnap.reference, {"MyPICUrl": newimgurl});
                });
              } on FirebaseException catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.message!)));
              }
            }
          },
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white70,
            child: Icon(
              Icons.mode_edit_rounded,
              color: Colors.black,
            ),
          ),
        ),
      ),
    ]);
  }
}
