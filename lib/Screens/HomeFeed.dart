import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialframe/ListLayouts/PostItemLayout.dart';
import 'package:socialframe/Routes.dart';
import 'package:socialframe/Screens/CreatePost.dart';

import '../Repository/DBHelper.dart';

class HomeFeed extends StatelessWidget {
  const HomeFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.CreatePost);
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: DBHelper.db
            .collection("FollowRelation")
            .where("FollowerID", isEqualTo: DBHelper.auth.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          } else if (snapshot.hasData) {
            var data = snapshot.data;
            var arr =
                data!.docs.map((e) => e.get("FollowedID").toString()).toList();
            return StreamBuilder(
              stream: DBHelper.db
                  .collection("Post")
                  .where("author", whereIn: arr)
                  .orderBy("key", descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error"),
                  );
                } else if (snapshot.hasData) {
                  var data = snapshot.data;
                  return ListView.builder(
                    itemCount: data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PostItemLayout(snap: data.docs[index]);
                    },
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
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
