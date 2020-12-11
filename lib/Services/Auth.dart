import 'package:bookhub/Services/database.dart';
import 'package:bookhub/models/user.dart';
import "package:firebase_auth/firebase_auth.dart";

class AuthService
{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User_ _userFromFireBaseUser(User user)
  {
    return user != null ? User_(uid: user.uid) : null;
  }
  Stream<User_> get user{
    return _auth.authStateChanges()
    .map((User user) => _userFromFireBaseUser(user));
  }
  //sign in anonymous
  Future signInAnon() async
  {
    try{
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFireBaseUser(user);
    }catch(e) {
      print(e.toString());
      return null;
    }
  }
  //sign in wih email & password
  Future signInWithEmail(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email,password: password);
      User user = result.user;
      return _userFromFireBaseUser(user);
    }on FirebaseAuthException catch(e){
      print(e.toString());
      return null;
    }
  }
  //register in wih email & password
  Future registerWithEmail(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email,password: password);
      User user = result.user;
      await DataBaseService(uid : user.uid).updateUserData("Achraf affes",email, password, "tunis");
      return _userFromFireBaseUser(user);
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