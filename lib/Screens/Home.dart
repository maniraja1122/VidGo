import 'package:VidGo/Repository/DBHelper.dart';
import 'package:VidGo/Screens/CreatePost.dart';
import 'package:VidGo/Screens/HomeFeed.dart';
import 'package:VidGo/Screens/ProfileShow.dart';
import 'package:VidGo/Screens/SearchUsers.dart';
import 'package:VidGo/Screens/ShowNotifications.dart';
import 'package:flutter/material.dart';

import '../Widgets/BottomNavigationBar.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
        child: Scaffold(
          body: TabBarView(
            children: [HomeFeed(),SearchUsers(),CreatePost(),ShowNotifications(),ProfileShow(id:DBHelper.auth.currentUser!.uid)],
          ),
          bottomNavigationBar:BottomNavBar()
        ));
  }
}
