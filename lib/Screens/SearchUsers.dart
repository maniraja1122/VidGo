import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialframe/ListLayouts/UserSearchGrid.dart';

import '../Repository/DBHelper.dart';

class SearchUsers extends StatefulWidget {
  SearchUsers({Key? key}) : super(key: key);

  @override
  State<SearchUsers> createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  var searchedtext="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(decoration: InputDecoration(hintText: "Search User Here",label: Text("Search")),onChanged: (val){
              searchedtext=val;
              setState((){});
            },),
            StreamBuilder(
              stream: DBHelper.db.collection("Users").orderBy("Name").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if(snapshot.hasError){
                  return Center(child: Text("Error"),);
                }
                else if(snapshot.hasData){
                  var arr=snapshot.data!.docs;
                  arr=arr.where((element) => element.get("Name").toString().toLowerCase().contains(searchedtext.toLowerCase())).toList();
                 return Expanded(
                   child: ListView.builder(itemBuilder:(context,index){
                      return UserSearchGrid(snapshot: arr[index]);
                    } ,itemCount: arr.length,),
                 );
                }
                return Center(child: CircularProgressIndicator(),);
              },
            )
          ],
        ),
      ),
    );
  }
}
