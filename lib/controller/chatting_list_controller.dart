import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../constants/firestore_constants.dart';

class ChattingListController extends GetxController{
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // "Cloud FireStore Databased"에 데이터를 갱신하는 역할
  Future<void> updateFirestoreData(
      String collectionPath, String path, Map<String, dynamic> updateData) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(updateData);
  }

  // "Cloud FireStore Databased"로부터 "data snapshot"을 전달 받는 역할
  Stream<QuerySnapshot> getFirestoreData(
      String collectionPath, int limit, String? textSearch) {
    if (textSearch?.isNotEmpty == true) {
      return firebaseFirestore
          .collection(collectionPath)
          .limit(limit)
          .where(FirestoreConstants.nickname, isEqualTo: textSearch)
          .snapshots();
    }else{
      return firebaseFirestore.collection(collectionPath).limit(limit).snapshots();
    }
  }
}