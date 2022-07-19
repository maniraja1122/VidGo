import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialframe/ListLayouts/ChatListGrid.dart';

import '../Repository/DBHelper.dart';


class ChatList extends StatefulWidget {
  ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Messages"),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: DBHelper.db.collection("Chat").where("user1",isEqualTo: DBHelper.auth.currentUser!.uid).orderBy("lastsend",descending: true).snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if(snapshot.hasError){
              return Center(child: Text("Error"),);
            }
            else if(snapshot.hasData){
              var arr=snapshot.data!.docs;
              return ListView.builder(itemBuilder:(context,index){
                return ChatListGrid(snap: arr[index]);
              } ,itemCount: arr.length,);
            }
            return Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }
}
