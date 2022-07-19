import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:socialframe/Repository/DBHelper.dart';
import 'package:socialframe/Routes.dart';
import 'package:socialframe/Screens/CreatePost.dart';
import 'package:socialframe/Screens/EditProfile.dart';
import 'package:socialframe/Screens/HomeFeed.dart';
import 'package:socialframe/Screens/ProfileShow.dart';
import 'package:socialframe/Screens/RegisterProcess/Login.dart';
import 'package:socialframe/Screens/RegisterProcess/Signup.dart';
import 'package:socialframe/firebase_options.dart';

import 'Screens/Home.dart';
import 'Screens/RegisterProcess/Selector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:DefaultFirebaseOptions.currentPlatform
  );
  FirebaseFirestore.instance.settings=Settings(persistenceEnabled: true,cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  runApp(HomeApp());
}
class HomeApp extends StatelessWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: DBHelper.auth.currentUser==null?Routes.Selector:Routes.Home,
      theme: ThemeData(primarySwatch: Colors.blue,fontFamily: GoogleFonts.lato().fontFamily,backgroundColor: Colors.white),
      darkTheme: ThemeData(primarySwatch: Colors.blue,fontFamily: GoogleFonts.lato().fontFamily,backgroundColor: Colors.white),
      routes: {
        Routes.Selector:(context)=>Selector(),
        Routes.Signup:(context)=>Signup(),
        Routes.Login:(context)=>Login(),
        Routes.Home:(context)=>Home(),
        Routes.EditProfile:(context)=>EditProfile(),
        Routes.CreatePost:(context)=>CreatePost(),
        Routes.HomeFeed:(context)=>HomeFeed()
      },
    );
  }
}
