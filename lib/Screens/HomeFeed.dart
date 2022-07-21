import 'package:VidGo/ListLayouts/PostItemLayout.dart';
import 'package:VidGo/Routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Repository/DBHelper.dart';

class HomeFeed extends StatefulWidget {
  HomeFeed({Key? key}) : super(key: key);

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  var check = "";

  @override
  void initState() {
    check = "foryou";
    //following/foryou
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Stack(
        children: [StreamBuilder(
                  stream: DBHelper.db
                      .collection("FollowRelation")
                      .where("FollowerID",
                          isEqualTo: DBHelper.auth.currentUser!.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error"),
                      );
                    } else if (snapshot.hasData) {
                      var data = snapshot.data;
                      var arr = data!.docs
                          .map((e) => e.get("FollowedID").toString())
                          .toList();
                      if (arr.length > 0 || check=="foryou") {
                        return StreamBuilder(
                          stream: check!="foryou"?DBHelper.db
                              .collection("Post")
                              .where("author",whereIn: arr)
                              .orderBy("key", descending: true)
                              .snapshots():DBHelper.db
                              .collection("Post")
                              .orderBy("key", descending: true)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text("Error"),
                              );
                            } else if (snapshot.hasData) {
                              var data = snapshot.data;
                              if(data!.docs.length>0) {
                                return PageView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: data.docs.length,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    return PostItemLayout(
                                        snap: data.docs[index]);
                                  },
                                );
                              }
                              else{
                                return Center(
                                    child: Text(
                                      "No Videos To Show",
                                      style: TextStyle(color: Colors.white,fontSize: 20),
                                    ));
                              }
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );
                      } else {
                        return Center(
                            child: Text(
                          "No Videos To Show",
                          style: TextStyle(color: Colors.white,fontSize: 20),
                        ));
                      }
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    check = "following";
                    setState(() {});
                  },
                  child: Text(
                    "Following",
                    style: TextStyle(
                        color: check == "foryou" ? Colors.grey : Colors.white,fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: InkWell(
                    onTap: () {
                      check = "foryou";
                      setState(() {});
                    },
                    child: Text(
                      "For You",
                      style: TextStyle(
                          color: check == "foryou" ? Colors.white : Colors.grey,fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
