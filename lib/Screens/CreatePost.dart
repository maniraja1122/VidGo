import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:socialframe/Repository/DBHelper.dart';
import 'package:socialframe/Screens/HomeFeed.dart';

import '../Routes.dart';

class CreatePost extends StatefulWidget {
  CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  File? selectedimg = null;
  var content = "";
  var loading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      dismissible: false,
      inAsyncCall: loading,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Create Post"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  onChanged: (val) {
                    content = val;
                  },
                  maxLength: 200,
                  maxLines: 10,
                  decoration:
                      InputDecoration(hintText: "What's in your mind....."),
                ),
                selectedimg == null
                    ? Card()
                    : Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Card(
                            child: Image(
                              fit: BoxFit.cover,
                              height: 200,
                              width: 200,
                              image: FileImage(selectedimg!),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              selectedimg = null;
                              setState(() {});
                            },
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.cancel,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () async {
                          var picked = await ImagePicker().pickImage(
                              source: ImageSource.gallery,
                              maxWidth: 1800,
                              maxHeight: 1800);
                          if (picked != null) {
                            selectedimg = File(picked.path);
                            setState(() {});
                          }
                        },
                        child: Icon(Icons.photo_library_outlined)),
                    ElevatedButton(
                        onPressed: () async {
                          if (selectedimg == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Please select an image first or wait for image to load !!!")));
                          } else {
                            setState(() {
                              loading = true;
                            });
                            await DBHelper.CreatePost(
                                title: content, image: selectedimg);
                            Navigator.pushNamedAndRemoveUntil(
                                context, Routes.Home, (route) => false);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Post Published Successfully")));
                          }
                        },
                        child: Text("Post"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
