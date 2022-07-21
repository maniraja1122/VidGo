

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../ListLayouts/CommentItem.dart';
import '../Models/Comment.dart';
import '../Models/Notifications.dart';
import '../Repository/DBHelper.dart';


class CommentBottomSheet extends StatelessWidget {
  QueryDocumentSnapshot snap;
  CommentBottomSheet({required this.snap,Key? key}) : super(key: key);
  var commenttext = "";
  var controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height-200,
      minHeight: 0),
      child: SingleChildScrollView(// Optional
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text("Comments",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),)),
                  InkWell(onTap: (){
                    Navigator.pop(context);
                  },child: Icon(Icons.cancel_outlined))
                ],
              ),
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
                  },itemCount:data!.docs.length,shrinkWrap: true);
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
