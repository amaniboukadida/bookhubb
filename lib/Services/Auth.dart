import 'package:bookhub/Services/database.dart';
import 'package:bookhub/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";

class AuthService
{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference users = DataBaseService().userCollection; 
  String username;
  String email;
  String location;
  String password;
  String uid;
  UserModel _userFromFireBaseUser(User user,String email,String password,String location,String username)
  {
    return user != null ? UserModel(uid: user.uid,email: email,password: password,location: location,username: username) : null;
  }
  Stream<UserModel> get user{
    return _auth.authStateChanges()
    .map((User user) => _userFromFireBaseUser(user,email,password,location,username));
  }
  //sign in anonymous
  /*Future signInAnon() async
  {
    try{
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFireBaseUser(user);
    }catch(e) {
      print(e.toString());
      return null;
    }
  }*/
  //sign in wih email & password
  Future signInWithEmail(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email,password: password);
      User user = result.user;
      uid = user.uid;
      users.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        username = documentSnapshot.get("username");
        email = documentSnapshot.get("email");
        location = documentSnapshot.get("location");
        password = documentSnapshot.get("password");
      } else {
        print('Document does not exist on the database');
      }
    });
      return _userFromFireBaseUser(user,email,password,location,username);
    }on FirebaseAuthException catch(e){
      print(e.toString());
      return null;
    }
  }
  //register in wih email & password
  Future registerWithEmail(String email, String username, String password, String location) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email,password: password);
      User user = result.user;
      uid = user.uid;
      await DataBaseService(uid : user.uid).updateUserData(username ,email, password, location, "");
      return _userFromFireBaseUser(user,email,password,location,username);
    }on FirebaseAuthException catch(e){
      print(e.toString());
      return null;
    }
  }
  //sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}