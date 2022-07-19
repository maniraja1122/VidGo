import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialframe/ListLayouts/PostItemLayout.dart';
import 'package:socialframe/Models/FollowRelation.dart';
import 'package:socialframe/Screens/MessageBox.dart';

import '../Repository/DBHelper.dart';

class ProfileShow extends StatelessWidget {
  var id = "";
  ProfileShow({required this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: DBHelper.db
            .collection("Users")
            .where("key", isEqualTo: id)
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
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                            style:
                                TextStyle(fontSize: 20, color: Colors.black54),
                          ),
                          StreamBuilder(
                            stream: DBHelper.db
                                .collection("Post")
                                .where("author", isEqualTo: id)
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
                                .where("FollowedID", isEqualTo: id)
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
                                .where("FollowerID", isEqualTo: id)
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
                      height: 20,
                    ),
                    id != DBHelper.auth.currentUser!.uid
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    await DBHelper.FollowUser(
                                        follower:
                                            DBHelper.auth.currentUser!.uid,
                                        followed: id);
                                  },
                                  child: StreamBuilder(
                                    stream: DBHelper.db
                                        .collection("FollowRelation")
                                        .where("FollowerID",
                                            isEqualTo:
                                                DBHelper.auth.currentUser!.uid)
                                        .where("FollowedID", isEqualTo: id)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<
                                                QuerySnapshot<
                                                    Map<String, dynamic>>>
                                            snapshot) {
                                      if (snapshot.hasError) {
                                        return Text("Follow");
                                      } else if (snapshot.hasData) {
                                        var count = snapshot.data?.docs.length;
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
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (c) =>
                                                  MessageBox(id: id)));
                                    },
                                    child: Text("Message")),
                              )
                            ],
                          )
                        : SizedBox(
                            height: 0,
                          ),
                      StreamBuilder(
                      stream: DBHelper.db
                          .collection("Post")
                          .where("author", isEqualTo: id).orderBy("key",descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                        if(snapshot.hasError){
                          print(snapshot.error.toString()+" mani");
                          return Center(child: Text("Error"),);
                        }
                        else if(snapshot.hasData){
                          return ListView.builder(physics: NeverScrollableScrollPhysics(),shrinkWrap: true,itemBuilder: (c,i){
                            return PostItemLayout(snap: snapshot.data!.docs[i]);
                          },itemCount: snapshot.data!.docs.length,);
                        }
                        return Center(child: CircularProgressIndicator(),);
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
    );
  }
}
