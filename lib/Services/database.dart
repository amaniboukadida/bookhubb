import "package:cloud_firestore/cloud_firestore.dart";

class DataBaseService{
  //collection reference
  final CollectionReference userCollection =  FirebaseFirestore.instance.collection("users");
  final CollectionReference bookCollection =  FirebaseFirestore.instance.collection("books");
  
  final String uid;
  DataBaseService({this.uid});
  Future updateUserData(String username, String email, String password, String location,String imageProfileUrl) async{
    return await userCollection.doc(uid).set({
      "username" : username,
      "password" : password,
      "email" : email,
      "location" : location,
      "imageProfileUrl" : imageProfileUrl
    });
  }
  Future<DocumentReference> updateBooksData({String title, String author, int pageNumbers, String genre, String location, String uid, String imageUrl}) async{ 
    DocumentReference test = await bookCollection.doc();
    test.set({
      "title" : title,
      "author" : author,
      "pageNumbers" : pageNumbers,
      "genre" : genre,
      "location" : location,
      "imageUrl" : imageUrl,
      "user_uid" : uid,
    });
    return test;
  }
}