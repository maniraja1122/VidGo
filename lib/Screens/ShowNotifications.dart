import 'package:VidGo/Screens/ChatList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:VidGo/ListLayouts/NotificationLayout.dart';
import 'dart:developer' as dev;
import '../Repository/DBHelper.dart';

class ShowNotifications extends StatelessWidget {
  const ShowNotifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Transform.rotate(
                angle: 340*3.14/180,
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (c)=> ChatList()));
                  },
              child: Icon(
                Icons.send_rounded,
              ),
            )),
          )
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: DBHelper.db
              .collection("Notifications")
              .where("targetuser", isEqualTo: DBHelper.auth.currentUser!.uid)
              .orderBy("key", descending: true)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              dev.log(snapshot.error.toString());
              return Center(child: Text("Error"));
            } else if (snapshot.hasData) {
              var data = snapshot.data;
              DBHelper.UpdateReadNotifications(data!.docs.length);
              if(data.docs.length>0) {
                return ListView.builder(
                  itemCount: data.docs.length,
                  itemBuilder: (c, i) => NotificationLayout(snap: data.docs[i]),
                );
              }
              else{
                 return Center(child: Text("All catched up !",style: TextStyle(fontSize: 22),));
              }
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
