import 'dart:io';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:VidGo/Repository/DBHelper.dart';
import 'package:VidGo/Screens/HomeFeed.dart';

import '../Routes.dart';

class CreatePost extends StatefulWidget {
  CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  File? selectedvid = null;
  var content = "";
  var loading = false;
  late CachedVideoPlayerController _controller;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(selectedvid!=null) {
      _controller = CachedVideoPlayerController.file(selectedvid!);
      _controller.initialize().then((value) async {
        if(_controller.value.duration.inSeconds>15){
          selectedvid=null;
          setState((){});
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a video less than 16 seconds")));
        }
        else {
          await _controller.setLooping(true);
          await _controller.setVolume(1);
          await _controller.play();
        }
      });
    }
    return ModalProgressHUD(
      dismissible: false,
      inAsyncCall: loading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Create Post",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
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
                selectedvid == null
                    ? Card()
                    : Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Card(
                            child: Container(
                              color: Colors.black,
                              width: 200,
                              height: 355,
                              child: CachedVideoPlayer(_controller),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              selectedvid = null;
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
                          var picked = await ImagePicker().pickVideo(
                              source: ImageSource.gallery,);
                          if (picked != null) {
                            selectedvid = File(picked.path);
                            setState(() {});
                          }
                        },
                        child: Icon(Icons.photo_library_outlined)),
                    ElevatedButton(
                        onPressed: () async {
                          if (selectedvid == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Please select an image first or wait for image to load !!!")));
                          } else {
                            setState(() {
                              loading = true;
                            });
                            await DBHelper.CreatePost(
                                title: content, image: selectedvid);
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
