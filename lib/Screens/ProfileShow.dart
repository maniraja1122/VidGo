import 'package:VidGo/ListLayouts/PostItemLayout.dart';
import 'package:VidGo/Screens/EditProfile.dart';
import 'package:VidGo/Screens/MessageBox.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Repository/DBHelper.dart';
import '../Routes.dart';

class ProfileShow extends StatefulWidget {
  var id = "";

  ProfileShow({required this.id, Key? key}) : super(key: key);

  @override
  State<ProfileShow> createState() => _ProfileShowState();
}

class _ProfileShowState extends State<ProfileShow> {
  List<CachedVideoPlayerController> arr = [];
  List<String> thumbnails = [];

  @override
  void dispose() {
    for (CachedVideoPlayerController c in arr) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: DBHelper.db
              .collection("Users")
              .where("key", isEqualTo: widget.id)
              .limit(1)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Text("Error");
            } else if (snapshot.hasData) {
              var data = snapshot.data!.docs[0];
              var name = data.get("Name");
              var desc = data.get("Description");
              var imgurl = data.get("MyPICUrl");
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      imgurl == ""
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage("assets/images/placeholder.png"),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(imgurl),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Text(
                          desc,
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(children: [
                            Text(
                              "Posts",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black54),
                            ),
                            StreamBuilder(
                              stream: DBHelper.db
                                  .collection("Post")
                                  .where("author", isEqualTo: widget.id)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      snapshot) {
                                if (snapshot.hasError) {
                                  return Text("Error");
                                } else if (snapshot.hasData) {
                                  var data = snapshot.data?.docs.length;
                                  return Text("$data",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold));
                                }
                                return Text("0",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold));
                              },
                            )
                          ]),
                          Column(children: [
                            Text("Followers",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black54)),
                            StreamBuilder(
                              stream: DBHelper.db
                                  .collection("FollowRelation")
                                  .where("FollowedID", isEqualTo: widget.id)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      snapshot) {
                                if (snapshot.hasError) {
                                  return Text("Error");
                                } else if (snapshot.hasData) {
                                  var data = snapshot.data?.docs.length;
                                  return Text("$data",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold));
                                }
                                return Text("0",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold));
                              },
                            )
                          ]),
                          Column(children: [
                            Text("Follows",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black54)),
                            StreamBuilder(
                              stream: DBHelper.db
                                  .collection("FollowRelation")
                                  .where("FollowerID", isEqualTo: widget.id)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      snapshot) {
                                if (snapshot.hasError) {
                                  return Text("Error");
                                } else if (snapshot.hasData) {
                                  var data = snapshot.data?.docs.length;
                                  return Text("$data",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold));
                                }
                                return Text("0",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold));
                              },
                            ),
                          ]),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      widget.id != DBHelper.auth.currentUser!.uid
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () async {
                                      await DBHelper.FollowUser(
                                          follower:
                                              DBHelper.auth.currentUser!.uid,
                                          followed: widget.id);
                                    },
                                    child: StreamBuilder(
                                      stream: DBHelper.db
                                          .collection("FollowRelation")
                                          .where("FollowerID",
                                              isEqualTo: DBHelper
                                                  .auth.currentUser!.uid)
                                          .where("FollowedID",
                                              isEqualTo: widget.id)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<
                                                  QuerySnapshot<
                                                      Map<String, dynamic>>>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          return Text("Follow");
                                        } else if (snapshot.hasData) {
                                          var count =
                                              snapshot.data?.docs.length;
                                          if (count! > 0) {
                                            return Text("Followed");
                                          } else {
                                            return Text("Follow");
                                          }
                                        }
                                        return Text("Follow");
                                      },
                                    )),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (c) =>
                                                    MessageBox(id: widget.id)));
                                      },
                                      child: Text("Message")),
                                )
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (c) => EditProfile()));
                                    },
                                    child: Text("Edit Profile")),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Logging Out"),
                                              content: Text(
                                                  "Do you want to log out ? "),
                                              actions: [
                                                ButtonBar(
                                                  children: [
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          DBHelper.auth
                                                              .signOut();
                                                          Navigator.of(context)
                                                              .pushNamedAndRemoveUntil(
                                                                  Routes
                                                                      .Selector,
                                                                  (route) =>
                                                                      false);
                                                        },
                                                        child: Text("Yes")),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("No"))
                                                  ],
                                                )
                                              ],
                                            );
                                          });
                                    },
                                    icon: Icon(Icons.logout))
                              ],
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      StreamBuilder(
                        stream: DBHelper.db
                            .collection("Post")
                            .where("author", isEqualTo: widget.id)
                            .orderBy("key", descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("Error"),
                            );
                          } else if (snapshot.hasData) {
                            thumbnails = snapshot.data!.docs
                                .map((e) => e.get("imagelink").toString())
                                .toList();
                            arr.clear();
                            for (String links in thumbnails) {
                              arr.add(
                                  CachedVideoPlayerController.network(links));
                              arr.last.initialize().then((value) => null);
                            }
                            return GridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 3,
                              children: List.generate(
                                  arr.length,
                                  (index) => InkWell(
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (c)=>PostItemLayout(snap: snapshot.data!.docs[index])));
                                    },
                                    child: Container(
                                      color: Colors.black,
                                      child: AspectRatio(
                                        aspectRatio: 9.0/16.0,
                                          child: CachedVideoPlayer(arr[index])),
                                    ),
                                  )),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
