import 'package:bookhub/Screens/Authentication/authenticate.dart';
import 'package:bookhub/Screens/Home/home.dart';
import 'package:bookhub/models/user.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User_>(context);
    print(user);
    if(user == null)
    {
      return Authenticate();
    }else{
      return Home();
    }
  }
}