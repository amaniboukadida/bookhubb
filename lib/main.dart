import 'package:bookhub/Screens/wrapper.dart';
import 'package:bookhub/Services/Auth.dart';
import 'package:bookhub/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        /* Check for errors
        if (snapshot.hasError) {
          return MaterialApp( home : error...() ) ;
        }

        // Once complete, show the application
         */
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<UserModel>.value(
            value: AuthService().user,
            child: 
              MaterialApp( 
                debugShowCheckedModeBanner: false,
                home : Wrapper() 
              )
            ) ;
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp( home : Loading() ) ;
      },
    );
  }
}

