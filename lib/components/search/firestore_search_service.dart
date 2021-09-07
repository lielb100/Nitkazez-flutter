import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class FirestoreServicePackage<T> {
  final String collectionName;
  final String searchBy;
  final List Function(QuerySnapshot) dataListFromSnapshot;
  final int limitOfRetrievedData;

  FirestoreServicePackage(
      {required this.collectionName,
      required this.searchBy,
      required this.dataListFromSnapshot,
      required this.limitOfRetrievedData});
  final FirebaseFirestore firebasefirestore = FirebaseFirestore.instance;

  Stream<List> searchData(String query, String userName) {
    final collectionReference = firebasefirestore.collection(collectionName);
    return collectionReference
        .where('$searchBy', isGreaterThanOrEqualTo: query)
        .where('userName', isNotEqualTo: userName)
        .limit(limitOfRetrievedData)
        .snapshots()
        .map(dataListFromSnapshot);
  }
}
