import 'package:flutter/cupertino.dart';

class UserModel{
  final String uid;
  String location;
  String username;
  String password;
  String email;
  String imageUrl;
  Widget avatarChild;
  UserModel({this.uid,this.email,this.location,this.username,this.password});
}