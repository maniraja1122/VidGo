import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialframe/ListLayouts/NotificationLayout.dart';
import 'dart:developer' as dev;
import '../Repository/DBHelper.dart';

class ShowNotifications extends StatelessWidget {
  const ShowNotifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: DBHelper.db
            .collection("Notifications")
            .where("targetuser", isEqualTo: DBHelper.auth.currentUser!.uid)
            .orderBy("key", descending: true)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if(snapshot.hasError){
            dev.log(snapshot.error.toString());
            return Center(child: Text("Error"));
          }
          else if(snapshot.hasData){
            var data=snapshot.data;
            DBHelper.UpdateReadNotifications(data!.docs.length);
            return ListView.builder(itemCount: data.docs.length,
              itemBuilder: (c,i)=>NotificationLayout(snap: data.docs[i]),);
          }
          return Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }
}
