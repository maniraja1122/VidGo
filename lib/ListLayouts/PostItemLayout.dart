import 'package:VidGo/Widgets/CommentBottomSheet.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:VidGo/Screens/ProfileShow.dart';
import 'package:share_plus/share_plus.dart';

import '../Repository/DBHelper.dart';

class PostItemLayout extends StatefulWidget {
  QueryDocumentSnapshot snap;

  PostItemLayout({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostItemLayout> createState() => _PostItemLayoutState();
}

class _PostItemLayoutState extends State<PostItemLayout> {
  late CachedVideoPlayerController _controller;

  @override
  void initState() {
    _controller =
        CachedVideoPlayerController.network(widget.snap.get("imagelink"));
    _controller.initialize().then((value) async {
      await _controller.setLooping(true);
      await _controller.setVolume(1);
      await _controller.play();
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var playing = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            InkWell(
                onTap: () {
                  playing = !playing;
                  if (playing) {
                    _controller.play();
                  } else {
                    _controller.pause();
                  }
                  setState(() {});
                },
                child: CachedVideoPlayer(_controller)),
            Align(
              alignment: AlignmentDirectional.center,
              child: playing
                  ? SizedBox()
                  : Icon(
                      Icons.play_arrow,
                      size: 50,
                      color: Colors.white,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 7, 100),
              child: Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StreamBuilder(
                      stream: DBHelper.db
                          .collection("Users")
                          .where("key", isEqualTo: widget.snap.get("author"))
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.hasError) {
                          return Text("Error");
                        } else if (snapshot.hasData) {
                          var data = snapshot.data!.docs[0];
                          return InkWell(
                            onTap: () {
                              var userkey = widget.snap.get("author");
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (c) => ProfileShow(id: userkey)));
                            },
                            child: Column(children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: data.get("MyPICUrl") == ""
                                      ? AssetImage(
                                              "assets/images/placeholder.png")
                                          as ImageProvider
                                      : NetworkImage(data.get("MyPICUrl")),
                                ),
                              ),
                              // Text(data.get("Name")),
                            ]),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: DBHelper.db
                          .collection("LikeRelation")
                          .where("PostKey", isEqualTo: widget.snap.get("key"))
                          .where("UserKey",
                              isEqualTo: DBHelper.auth.currentUser!.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        InkWell commenticon = InkWell(
                          child: Icon(
                            Icons.mode_comment_rounded,
                            color: Colors.white,
                            size: 35,
                          ),
                          onTap: () {
                            showBottomSheet(
                                context: context,
                                builder: (c) => CommentBottomSheet(snap: widget.snap));
                          },
                        );
                        if (snapshot.hasError) {
                          return Text("Error");
                        } else if (snapshot.hasData) {
                          var data = snapshot.data;
                          if (data!.docs.length > 0) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () async {
                                    await DBHelper.LikePost(
                                        widget.snap.get("key"));
                                  },
                                  child: Icon(
                                    CupertinoIcons.heart_solid,
                                    color: Colors.red,
                                    size: 35,
                                  ),
                                ),
                                StreamBuilder(
                                  stream: DBHelper.db
                                      .collection("LikeRelation")
                                      .where("PostKey",
                                          isEqualTo: widget.snap.get("key"))
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<
                                              QuerySnapshot<Map<String, dynamic>>>
                                          snapshot) {
                                    if (snapshot.hasError) {
                                      return Text("Error");
                                    } else if (snapshot.hasData) {
                                      var count = snapshot.data!.docs.length;
                                      return Text(count.toString(),
                                          style: TextStyle(color: Colors.white));
                                    }
                                    return Text("0",
                                        style: TextStyle(color: Colors.white));
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                commenticon,
                                StreamBuilder(
                                  stream: DBHelper.db
                                      .collection("Comment")
                                      .where("postkey",
                                          isEqualTo: widget.snap.get("key"))
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<
                                              QuerySnapshot<Map<String, dynamic>>>
                                          snapshot) {
                                    if (snapshot.hasError) {
                                      return Text("Error");
                                    } else if (snapshot.hasData) {
                                      var count = snapshot.data!.docs.length;
                                      return Text(count.toString(),
                                          style: TextStyle(color: Colors.white));
                                    }
                                    return Text("0",
                                        style: TextStyle(color: Colors.white));
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                    onTap: () async {
                                      await Share.share(
                                        "Watch this on VidGo official app and be a member of the VidGo family",
                                        subject: "Share this",
                                      );
                                    },
                                    child: Icon(
                                      Icons.share,
                                      size: 35,
                                      color: Colors.white,
                                    )),
                                Text("Share",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14))
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () async {
                                    await DBHelper.LikePost(
                                        widget.snap.get("key"));
                                  },
                                  child: Icon(
                                    CupertinoIcons.heart_fill,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                                StreamBuilder(
                                  stream: DBHelper.db
                                      .collection("LikeRelation")
                                      .where("PostKey",
                                          isEqualTo: widget.snap.get("key"))
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<
                                              QuerySnapshot<Map<String, dynamic>>>
                                          snapshot) {
                                    if (snapshot.hasError) {
                                      return Text("Error");
                                    } else if (snapshot.hasData) {
                                      var count = snapshot.data!.docs.length;
                                      return Text(
                                        count.toString(),
                                        style: TextStyle(color: Colors.white),
                                      );
                                    }
                                    return Text("0",
                                        style: TextStyle(color: Colors.white));
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                commenticon,
                                StreamBuilder(
                                  stream: DBHelper.db
                                      .collection("Comment")
                                      .where("postkey",
                                          isEqualTo: widget.snap.get("key"))
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<
                                              QuerySnapshot<Map<String, dynamic>>>
                                          snapshot) {
                                    if (snapshot.hasError) {
                                      return Text("Error");
                                    } else if (snapshot.hasData) {
                                      var count = snapshot.data!.docs.length;
                                      return Text(count.toString(),
                                          style: TextStyle(color: Colors.white));
                                    }
                                    return Text("0",
                                        style: TextStyle(color: Colors.white));
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                    onTap: () async {
                                      await Share.share(
                                        "Watch this on VidGo official app and be a member of the VidGo family",
                                        subject: "Share this",
                                      );
                                    },
                                    child: Icon(
                                      Icons.share,
                                      size: 35,
                                      color: Colors.white,
                                    )),
                                Text("Share",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14))
                              ],
                            );
                          }
                        }
                        return SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 55, 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder(
                      stream: DBHelper.db
                          .collection("Users")
                          .where("key", isEqualTo: widget.snap.get("author"))
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.hasError) {
                          return Text("Error");
                        } else if (snapshot.hasData) {
                          var data = snapshot.data!.docs[0];
                          return InkWell(
                              onTap: () {
                                var userkey = widget.snap.get("author");
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (c) => ProfileShow(id: userkey)));
                              },
                              child: Text("@" + data.get("Name"),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)));
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    widget.snap.get("title") == ""
                        ? SizedBox(
                            height: 0,
                          )
                        : Text(widget.snap.get("title"),
                            style: TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
