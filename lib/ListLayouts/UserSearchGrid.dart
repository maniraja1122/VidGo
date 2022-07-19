import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialframe/Screens/ProfileShow.dart';

class UserSearchGrid extends StatelessWidget {
  QueryDocumentSnapshot snapshot;
  UserSearchGrid({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        leading: (snapshot.get("MyPICUrl"))==""?CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage("assets/images/placeholder.png"),
        ): CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(snapshot.get("MyPICUrl")),
        ),
        title: Text(snapshot.get("Name"),maxLines: 1,),
        subtitle: Text(snapshot.get("Description"),maxLines: 3,overflow: TextOverflow.ellipsis ,),
        trailing: ElevatedButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (c)=>
            ProfileShow(id: snapshot.get("key"))
          ));
        },child: Text("Visit"),),
      ),
    );
  }
}
