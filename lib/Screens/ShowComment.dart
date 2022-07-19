import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialframe/ListLayouts/CommentItem.dart';
import 'package:socialframe/Screens/ProfileShow.dart';

import '../Models/Comment.dart';
import '../Models/Notifications.dart';
import '../Repository/DBHelper.dart';
class ShowComment extends StatelessWidget {
  QueryDocumentSnapshot snap;
  ShowComment({Key? key, required this.snap}) : super(key: key);
  @override
  var commenttext = "";
  var controller = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                    onTap: () {
                      var userkey = snap.get("author");
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) => ProfileShow(id: userkey)));
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
                  .collection("Comment")
                  .where("postkey", isEqualTo: snap.get("key"))
                  .orderBy("key")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                      snapshot) {
                if(snapshot.hasError){
                  return Text("Error");
                }
                else if(snapshot.hasData){
                  var data=snapshot.data;
                  return ListView.builder(physics: NeverScrollableScrollPhysics(),itemBuilder:(c,i){
                    return CommentItem(snap: data!.docs[i]);
                  },itemCount:data!.docs.length,shrinkWrap: true,);
                }
                return Center(child: CircularProgressIndicator(),);
              },
            ),
            Row(
              children: [
                Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: TextFormField(
                          onChanged: (val) {
                            commenttext = val;
                          },
                          controller: controller,
                          decoration: InputDecoration(
                              hintText: "Enter Comment Here")),
                    )),
                ElevatedButton(
                    onPressed: () async {
                      if (commenttext != "") {
                        await DBHelper.db.collection("Comment").add(Comment(
                            postkey: snap.get("key"),
                            userkey: DBHelper.auth.currentUser!.uid,
                            text: commenttext)
                            .toMap());
                        controller.clear();
                        var allusers=await DBHelper.db.collection("Users").where("key",isEqualTo:DBHelper.auth.currentUser!.uid).get();
                        var myuser=allusers.docs[0];
                        await DBHelper.db.collection("Notifications").add(Notifications(
                            targetuser: snap.get("author"),
                            mytext: myuser.get("Name")+" commented on your post",
                            type: "3",
                            VisitingUnit: snap.get("key").toString(),
                            imgurl:snap.get("imagelink"))
                            .toMap());
                        commenttext = "";
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Enter a comment first")));
                      }
                    },
                    child: Icon(Icons.send))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
