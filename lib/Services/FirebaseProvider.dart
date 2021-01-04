import 'package:bookhub/Services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProvider {
  Future<List<List<DocumentSnapshot>>> fetchFirstList(String searchCategory,String searchLocation, String searchedBookName) async {
    Query query;
    if(searchCategory!="All"&&searchLocation!="All")
    {
      query = DataBaseService().bookCollection.limit(5).where("location", isEqualTo: searchLocation).where("genre",isEqualTo:searchCategory);
    }else if(searchCategory!="All"&&searchLocation=="All")
    {
      query = DataBaseService().bookCollection.limit(5).where("genre",isEqualTo:searchCategory);    
    }else if(searchCategory=="All"&&searchLocation!="All")
    {
      query = DataBaseService().bookCollection.limit(5).where("location",isEqualTo:searchLocation);
    }else{
      query = DataBaseService().bookCollection.limit(5);     
    }
    List<List<DocumentSnapshot>> returnedValue =[[],[]];
    List<DocumentSnapshot> allDocList = (await query.get()).docs;
    returnedValue[0].addAll(allDocList);
    List<QueryDocumentSnapshot> test = [];
    if(searchedBookName!=""){
      (await query.get()).docs.forEach((element) {
        if(element.get("title").toString().toLowerCase().contains(searchedBookName.toLowerCase())){
          test.add(element);
        }
      });
    }else{
      test = allDocList;
    }
    returnedValue[1].addAll(test);
    return returnedValue;
  }

  Future<List<List<DocumentSnapshot>>> fetchNextList(
      List<DocumentSnapshot> documentList,String searchCategory,String searchLocation, String searchedBookName) async {
         Query query;
    if(searchCategory!="All"&&searchLocation!="All")
    {
      query = DataBaseService().bookCollection.limit(5).where("location", isEqualTo: searchLocation).where("genre",isEqualTo:searchCategory);
    }else if(searchCategory!="All"&&searchLocation=="All")
    {
      query = DataBaseService().bookCollection.limit(5).where("genre",isEqualTo:searchCategory);    
    }else if(searchCategory=="All"&&searchLocation!="All")
    {
      query = DataBaseService().bookCollection.limit(5).where("location",isEqualTo:searchLocation);
    }else{
      query = DataBaseService().bookCollection.limit(5);     
    }
    List<List<DocumentSnapshot>> returnedValue =[[],[]];
    print("HERE 1");
    List<DocumentSnapshot> allDocList = (await query.startAfterDocument(documentList[documentList.length - 1]).get()).docs;
    print("HERE 1");
    returnedValue[0].addAll(allDocList);
    List<QueryDocumentSnapshot> test = [];
    print("HERE 2");
    if(searchedBookName!=""){
      (await query.startAfterDocument(documentList[documentList.length - 1]).get()).docs.forEach((element) {
        if(element.get("title").toString().toLowerCase().contains(searchedBookName.toLowerCase())){
          test.add(element);
          print("test.length : "+test.length.toString());
        }
      });
    }else{
      test = allDocList;
    }
    returnedValue[1].addAll(test);
    return returnedValue;
  }
}