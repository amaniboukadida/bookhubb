import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import "package:bookhub/Services/FirebaseProvider.dart";
class BookListBloc {
  FirebaseProvider firebaseProvider;

  bool showIndicator = false;
  List<List<DocumentSnapshot>> documentList;

  BehaviorSubject<List<List<DocumentSnapshot>>> bookController;

  BehaviorSubject<bool> showIndicatorController;

  BookListBloc() {
    bookController = BehaviorSubject<List<List<DocumentSnapshot>>>();
    showIndicatorController = BehaviorSubject<bool>();
    firebaseProvider = FirebaseProvider();
  }

  Stream get getShowIndicatorStream => showIndicatorController.stream;

  Stream<List<List<DocumentSnapshot>>> get bookStream => bookController.stream;

/*This method will automatically fetch first 10 elements from the document list */
  Future fetchFirstList(String searchCategory,String searchLocation,String searchedBookName) async {
    try {
      documentList = await firebaseProvider.fetchFirstList(searchCategory,searchLocation,searchedBookName);
      bookController.sink.add(documentList);
      try {
        if (documentList.length == 0) {
          bookController.sink.addError("No Data Available");
        }
      } catch (e) {}
    } on SocketException {
      bookController.sink.addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      bookController.sink.addError(e);
    }
  }

/*This will automatically fetch the next 10 elements from the list*/
  fetchNextBooks(String searchCategory,String searchLocation, String searchedBookName) async {
    try {
      updateIndicator(true);
      List<List<DocumentSnapshot>> newDocumentList =
        await firebaseProvider.fetchNextList(documentList[0],searchCategory,searchLocation,searchedBookName);
      documentList[1].addAll(newDocumentList[1]);
      documentList[0].addAll(newDocumentList[0]);
      bookController.sink.add(documentList);
      try {
        if (documentList.length == 0) {
          bookController.sink.addError("No Data Available");
          updateIndicator(false);
        }
      } catch (e) {
        updateIndicator(false);
      }
    } on SocketException {
      bookController.sink.addError(SocketException("No Internet Connection"));
      updateIndicator(false);
    } catch (e) {
      updateIndicator(false);
      print(e.toString());
      bookController.sink.addError(e);
    }
  }

/*For updating the indicator below every list and paginate*/
  updateIndicator(bool value) async {
    showIndicator = value;
    showIndicatorController.sink.add(value);
  }

  void dispose() {
    bookController.close();
    showIndicatorController.close();
  }
}