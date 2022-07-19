import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialframe/Screens/ProfileShow.dart';
import 'package:socialframe/Screens/ShowComment.dart';

import '../Repository/DBHelper.dart';



class NotificationLayout extends StatelessWidget {
  QueryDocumentSnapshot snap;
  NotificationLayout({required this.snap,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if(snap.get("type")=="2" || snap.get("type")=="3"){
          var alldata=await DBHelper.db.collection("Post").where("key",isEqualTo:int.parse(snap.get("VisitingUnit"))).get();
          Navigator.of(context).push(MaterialPageRoute(builder: (c)=>ShowComment(snap:alldata.docs[0])));
        }
        else{
          Navigator.of(context).push(MaterialPageRoute(builder:(c)=>ProfileShow(id: snap.get("VisitingUnit"))));
        }
      },
      child: Card(
        child: ListTile(
          leading:snap.get("imgurl")==""?CircleAvatar(radius: 25,backgroundImage: AssetImage("assets/images/placeholder.png"),):CircleAvatar(radius: 25,backgroundImage: NetworkImage(snap.get("imgurl")),),
          title: Text(snap.get("mytext")),
        ),
      ),
    );
  }
}
