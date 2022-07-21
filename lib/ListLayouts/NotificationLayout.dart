import 'dart:io';

import 'package:VidGo/ListLayouts/PostItemLayout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:VidGo/Screens/ProfileShow.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../Repository/DBHelper.dart';
import 'dart:developer' as dev;


class NotificationLayout extends StatelessWidget {
  QueryDocumentSnapshot snap;
  NotificationLayout({required this.snap,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if(snap.get("type")=="2" || snap.get("type")=="3"){
          var alldata=await DBHelper.db.collection("Post").where("key",isEqualTo:int.parse(snap.get("VisitingUnit"))).get();
          Navigator.of(context).push(MaterialPageRoute(builder: (c)=>PostItemLayout(snap:alldata.docs[0])));
        }
        else{
          Navigator.of(context).push(MaterialPageRoute(builder:(c)=>ProfileShow(id: snap.get("VisitingUnit"))));
        }
      },//snap.get("imgurl")==""?CircleAvatar(radius: 25,backgroundImage: AssetImage("assets/images/placeholder.png"),):CircleAvatar(radius: 25,backgroundImage: NetworkImage(snap.get("imgurl")),),
      child: Card(
        child: ListTile(
          leading: FutureBuilder(
            future: GetTile(), builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              if(snapshot.hasError){
                dev.log(snapshot.error.toString());
                return Text("Error");
              }
              else if(snapshot.hasData){
                return snapshot.data!;
              }
              return CircleAvatar(radius: 25,backgroundImage: AssetImage("assets/images/placeholder.png"),);
          },
          ),
          title: Text(snap.get("mytext")),
        ),
      ),
    );
  }
  Future<Widget> GetTile() async {
    if(snap.get("imgurl")==""){
      return CircleAvatar(radius: 25,backgroundImage: AssetImage("assets/images/placeholder.png"),);
    }
    switch(snap.get("type")) {
      case "1":
    return CircleAvatar(radius: 25, backgroundImage: NetworkImage(snap.get("imgurl")),);
      case "2":
      case "3":
      final fileName = await VideoThumbnail.thumbnailData(
          video: snap.get("imgurl"),
    imageFormat: ImageFormat.WEBP,
    maxHeight: 89, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    quality: 50,
    );
        return CircleAvatar(radius: 25, backgroundImage:MemoryImage(fileName!),);
  }
  return CircleAvatar(radius: 25,backgroundImage: AssetImage("assets/images/placeholder.png"),);
  }
}
