import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialframe/Screens/ProfileShow.dart';
import 'package:socialframe/Screens/ShowComment.dart';

import '../Repository/DBHelper.dart';

class PostItemLayout extends StatelessWidget {
  QueryDocumentSnapshot snap;
  PostItemLayout({Key? key, required this.snap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          StreamBuilder(
            stream: DBHelper.db
                .collection("Users")
                .where("key", isEqualTo: snap.get("author"))
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasError) {
                return Text("Error");
              } else if (snapshot.hasData) {
                var data = snapshot.data!.docs[0];
                return ListTile(
                  onTap: (){
                    var userkey=snap.get("author");
                    Navigator.of(context).push(MaterialPageRoute(builder: (c)=>ProfileShow(id: userkey)));
                  },
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: data.get("MyPICUrl") == ""
                        ? AssetImage("assets/images/placeholder.png")
                            as ImageProvider
                        : NetworkImage(data.get("MyPICUrl")),
                  ),
                  title: Text(data.get("Name")),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          snap.get("title") == ""
              ? SizedBox(
                  height: 0,
                )
              : Text(snap.get("title")),
          Card(
            child: Image.network(snap.get("imagelink"),
                height: 400, width: 400, fit: BoxFit.cover),
          ),
          StreamBuilder(
            stream: DBHelper.db
                .collection("LikeRelation")
                .where("PostKey", isEqualTo: snap.get("key"))
                .where("UserKey", isEqualTo: DBHelper.auth.currentUser!.uid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              InkWell commenticon = InkWell(child: Icon(Icons.mode_comment_outlined),onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (c)=>ShowComment(snap: snap)));
              },);
              if (snapshot.hasError) {
                return Text("Error");
              } else if (snapshot.hasData) {
                var data = snapshot.data;
                if (data!.docs.length > 0) {
                  return Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          await DBHelper.LikePost(snap.get("key"));
                        },
                        child: Icon(
                          CupertinoIcons.heart_fill,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      StreamBuilder(
                        stream: DBHelper.db
                            .collection("LikeRelation")
                            .where("PostKey", isEqualTo: snap.get("key"))
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.hasError) {
                            return Text("Error");
                          } else if (snapshot.hasData) {
                            var count = snapshot.data!.docs.length;
                            return Text(count.toString());
                          }
                          return Text("0");
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      commenticon,
                      SizedBox(
                        width: 5,
                      ),
                      StreamBuilder(
                        stream: DBHelper.db
                            .collection("Comment")
                            .where("postkey", isEqualTo: snap.get("key"))
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.hasError) {
                            return Text("Error");
                          } else if (snapshot.hasData) {
                            var count = snapshot.data!.docs.length;
                            return Text(count.toString());
                          }
                          return Text("0");
                        },
                      ),
                    ],
                  );
                } else {
                  return Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          await DBHelper.LikePost(snap.get("key"));
                        },
                        child: Icon(
                          CupertinoIcons.heart,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      StreamBuilder(
                        stream: DBHelper.db
                            .collection("LikeRelation")
                            .where("PostKey", isEqualTo: snap.get("key"))
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.hasError) {
                            return Text("Error");
                          } else if (snapshot.hasData) {
                            var count = snapshot.data!.docs.length;
                            return Text(count.toString());
                          }
                          return Text("0");
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      commenticon,
                      SizedBox(
                        width: 5,
                      ),
                      StreamBuilder(
                        stream: DBHelper.db
                            .collection("Comment")
                            .where("postkey", isEqualTo: snap.get("key"))
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.hasError) {
                            return Text("Error");
                          } else if (snapshot.hasData) {
                            var count = snapshot.data!.docs.length;
                            return Text(count.toString());
                          }
                          return Text("0");
                        },
                      ),
                    ],
                  );
                }
              }
              return Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      await DBHelper.LikePost(snap.get("key"));
                    },
                    child: Icon(
                      CupertinoIcons.heart,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("0"),
                  SizedBox(
                    width: 20,
                  ),
                  commenticon,
                  SizedBox(
                    width: 5,
                  ),
                  Text("0")
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
