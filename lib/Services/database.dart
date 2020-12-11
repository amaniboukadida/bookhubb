import "package:cloud_firestore/cloud_firestore.dart";

class DataBaseService{
  //collection reference
  final CollectionReference userCollection =  FirebaseFirestore.instance.collection("users");
  
  final String uid;
  DataBaseService({this.uid});
  Future updateUserData(String username, String email, String password, String location) async{
    return await userCollection.doc(uid).set({
      "username" : username,
      "password" : password,
      "email" : email,
      "location" : location,
    });
  }
}