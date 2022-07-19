import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialframe/Repository/DBHelper.dart';
import 'package:socialframe/Screens/MessageBox.dart';

class ChatListGrid extends StatelessWidget {
  QueryDocumentSnapshot snap;
  ChatListGrid({required this.snap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (c)=>MessageBox(id: snap.get("user2"))));
      },
      child: Card(
              child: ListTile(
                leading: StreamBuilder(
                  stream: DBHelper.db
                      .collection("Users")
                      .where("key", isEqualTo: snap.get("user2"))
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data;
                      return CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            NetworkImage(data!.docs[0].get("MyPICUrl")),
                      );
                    }
                    return CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          AssetImage("assets/images/placeholder.png"),
                    );
                  },
                ),
                title: StreamBuilder(
                  stream: DBHelper.db
                      .collection("Users")
                      .where("key", isEqualTo: snap.get("user2"))
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data;
                      return Text(data!.docs[0].get("Name"));
                    }
                    return Text("Fetching...");
                  },
                ),
                subtitle: StreamBuilder(
                  stream: DBHelper.db
                      .collection("MessageModel")
                      .where("chatkey", isEqualTo: snap.get("key"))
                      .orderBy("messagekey", descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data;
                      if(data!.docs.length>0)
                      return Text(data.docs[0].get("message"));
                      else{
                        return Text("");
                      }
                    }
                    return Text("fetching");
                  },
                ),
              ),
            ),
    );
  }
}
