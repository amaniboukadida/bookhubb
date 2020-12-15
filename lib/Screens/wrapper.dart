import 'package:bookhub/Screens/Authentication/authenticate.dart';
import 'package:bookhub/Screens/Home/home.dart';
import 'package:bookhub/Services/database.dart';
import 'package:bookhub/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User_>(context);
    if(user == null)
    {
      return Authenticate();
    }else{
      DataBaseService().userCollection.doc(user.uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        user.username = documentSnapshot.get("username");
        user.email = documentSnapshot.get("email");
        user.location = documentSnapshot.get("location");
        user.password = documentSnapshot.get("password");
      } else {
        print('Document does not exist on the database');
      }
      });
      return Home(user: user,);
    }
  }
}