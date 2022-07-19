import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialframe/Repository/DBHelper.dart';
import 'package:socialframe/Screens/ProfileShow.dart';

class CommentItem extends StatelessWidget {
  QueryDocumentSnapshot snap;
  CommentItem({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: StreamBuilder(
          stream: DBHelper.db
              .collection("Users")
              .where("key", isEqualTo: snap.get("userkey"))
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
      var visitprof=(){Navigator.of(context).push(MaterialPageRoute(builder: (c)=>ProfileShow(id: snap.get("userkey"))));};
            if(snapshot.hasData){
              var data=snapshot.data;
              if(data!.docs[0].get("MyPICUrl")!="")
              return InkWell(onTap: visitprof,child: CircleAvatar(radius: 25,backgroundImage: NetworkImage(data.docs[0].get("MyPICUrl")),));
            }
              return InkWell(onTap: visitprof,child: CircleAvatar(radius: 25,backgroundImage: AssetImage("assets/images/placeholder.png"),));
          },
        ),
        title: StreamBuilder(
          stream: DBHelper.db
              .collection("Users")
              .where("key", isEqualTo: snap.get("userkey"))
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if(snapshot.hasData){
              var data=snapshot.data;
              return Text(data!.docs[0].get("Name"));
            }
            return Text("Fetching");
          },
        ),
        subtitle: Text(snap.get("text")),
      ),
    );
  }
}
