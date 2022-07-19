import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialframe/ListLayouts/MessageItem.dart';
import 'package:socialframe/Repository/AuthHelper.dart';


import '../Repository/DBHelper.dart';

class MessageBox extends StatelessWidget {
  String id;
  String newmessage = "";
  var controller=TextEditingController();
  MessageBox({required this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: StreamBuilder(
          stream: DBHelper.db
              .collection("Users")
              .where("key", isEqualTo: id)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Text("Error");
            } else if (snapshot.hasData) {
              var data = snapshot.data!.docs[0];
              return Text(data.get("Name"));
            }
            return Text("Fetching");
          },
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder(
              stream: DBHelper.db
                  .collection("MessageModel")
                  .where("chatkey",
                      isEqualTo: DBHelper.auth.currentUser!.uid + id).orderBy("messagekey",descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error"),
                  );
                } else if (snapshot.hasData) {
                  var arr = snapshot.data!.docs;
                  return ListView.builder(
                    reverse: true,
                      itemCount: arr.length,
                      itemBuilder: (c, i) {
                        return MessageItem(snap: arr[i]);
                      });
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Row(
            children: [
              Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: TextFormField(
                      controller: controller,
                      onChanged: (val){
                        newmessage=val;
                      },
                autofocus: true,
                decoration: InputDecoration(hintText: "Enter Message Here"),
              ),
                  )),
              ElevatedButton(onPressed: (){
                DBHelper.SendMessage(user1: DBHelper.auth.currentUser!.uid, user2: id, message: newmessage);
                newmessage="";
                controller.clear();
              }, child: Icon(Icons.send))
            ],
          )
        ],
      ),
    );
  }
}
