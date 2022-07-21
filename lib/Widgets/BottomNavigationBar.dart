import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:VidGo/Repository/DBHelper.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      unselectedLabelColor: Colors.grey,
      indicatorWeight: 5,
      labelColor: Colors.black,
      tabs: [
        Tab(
          icon: Icon(Icons.home),
        ),
        Tab(
          icon: Icon(Icons.search),
        ),
        Tab(
          icon: Container(child: Icon(Icons.add,color: Colors.white,),width: 40,height: 30,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.black),),
        ),
        Tab(
          child: Badge(
            child: Icon(Icons.inbox),
            badgeContent: StreamBuilder(
                stream: DBHelper.db
                    .collection("Users")
                    .where("key", isEqualTo: DBHelper.auth.currentUser!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
              if (snapshot.hasError) {
                return Text("0");
              } else if (snapshot.hasData) {
                var data = snapshot.data;
                var user = data!.docs[0];
                var readnotifications = user.get("ReadNotifications");
                return StreamBuilder(
                  stream: DBHelper.db
                      .collection("Notifications")
                      .where("targetuser",
                          isEqualTo: DBHelper.auth.currentUser!.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasData) {
                      var current = snapshot.data!.docs.length;
                      return Text("${current - readnotifications}");
                    }
                    return Text("0");
                  },
                );
              }
              return Text("0");
            },
          ),
        ),),
        Tab(
          icon: Icon(Icons.person_outline_outlined,),
        ),
      ],
    );
  }
}
