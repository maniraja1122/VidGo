import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialframe/Repository/DBHelper.dart';
import 'package:socialframe/Widgets/BelowCameraStack.dart';
import 'package:socialframe/Widgets/MyDrawer.dart';
import 'package:flutter/services.dart';

import '../Routes.dart';

class EditProfile extends StatelessWidget {
  EditProfile({Key? key}) : super(key: key);
  var newname = "";
  var newdesc = "";
  var fkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              if (fkey.currentState!.validate()) {
                DBHelper.db.runTransaction((transaction) async {
                  var data=await DBHelper.db
                      .collection("Users")
                      .where("key", isEqualTo: DBHelper.auth.currentUser!.uid).get();
                  var currentsnap=data.docs[0].reference;
                  var securesnap=await transaction.get(currentsnap);
                  transaction.update(securesnap.reference,{
                    "Name":newname,
                    "Description":newdesc
                  });
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data Saved Successfully")));
                Navigator.pushNamed(context, Routes.Home);
              }
            },
            icon: Icon(Icons.check),
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          )
        ],
      ),
      body: StreamBuilder(
        stream: DBHelper.db
            .collection("Users")
            .where("key", isEqualTo: DBHelper.auth.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Text("Error");
          } else if (snapshot.hasData) {
            var data = snapshot.data!.docs[0];
            var imgurl = data.get("MyPICUrl");
            var name = data.get("Name");
            var desc = data.get("Description");
            newname=name;
            newdesc=desc;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: fkey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      imgurl == ""
                          ? CircleAvatar(
                              child: BelowCameraStack(),
                              radius: 50,
                              backgroundImage:
                                  AssetImage("assets/images/placeholder.png"),
                            )
                          : CircleAvatar(
                              child: BelowCameraStack(),
                              radius: 50,
                              backgroundImage: NetworkImage(imgurl),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "PUBLIC INFORMATION",
                        style: TextStyle(color: Colors.black54),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (val) {
                          if (val!.length > 5) {
                            return null;
                          }
                          return "Length should be atleast 6 chars";
                        },
                        onChanged: (val) {
                          newname = val;
                        },
                        initialValue: name,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Name"),
                            hintText: "Enter Name Here"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (val) {
                          newdesc = val;
                        },
                        maxLines: 3,
                        maxLength: 100,
                        initialValue: desc,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Description"),
                            hintText: "Enter Description Here"),
                      ),
                    ],
                  ),
                ),
              ),
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
