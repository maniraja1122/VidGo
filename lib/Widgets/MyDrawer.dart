import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialframe/Repository/DBHelper.dart';
import 'package:socialframe/Screens/ProfileShow.dart';

import '../Routes.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          StreamBuilder(
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
                var imgurl=data.get("MyPICUrl");
                return UserAccountsDrawerHeader(
                    currentAccountPicture:imgurl!=""?CircleAvatar(radius: 50,backgroundImage:  NetworkImage(imgurl),)
                    :CircleAvatar(radius: 50,backgroundImage: AssetImage("assets/images/placeholder.png"),),
                    accountName: Text(data.get("Name")),
                    accountEmail: Text(data.get("Email")));
              }
              return UserAccountsDrawerHeader(
                  currentAccountPicture:CircleAvatar(radius: 50,backgroundImage: AssetImage("assets/images/placeholder.png"),),
                  accountName: Text("Fetching...."),
                  accountEmail: Text("Fetching"));
            },
          ),
          ListTile(onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileShow(id: DBHelper.auth.currentUser!.uid)));
          },leading: Icon(Icons.person),title: Text("My Profile"),),
          ListTile(onTap: (){Navigator.of(context).pushNamed(Routes.EditProfile);},leading: Icon(Icons.edit),title: Text("Edit Profile"),),
          ListTile(onTap: (){
            showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) {
              return AlertDialog(title: Text("Logging Out"),content: Text("Do you want to log out ? "),actions: [
                ButtonBar(children: [
                  ElevatedButton(onPressed: (){DBHelper.auth.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(Routes.Selector, (route) => false);}, child: Text("Yes")),
                  ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("No"))
                ],)
              ],);
            });
          },leading: Icon(Icons.logout),title: Text("Log Out"),),
        ],
      ),
    );
  }
}
