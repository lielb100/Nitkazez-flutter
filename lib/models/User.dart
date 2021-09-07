import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? uid;
  String? userName;

  User(this.uid, this.userName);

  User.fromObject({this.uid, this.userName});

  User.fromSnapshot(String id, Map<String, dynamic> snapshot)
      : uid = id,
        userName = snapshot['userName'];

  double get balance => 0.0;
  // Future<double> get balance async {
  //   var doc = FirebaseFirestore.instance.collection("users").doc(this._uid);
  //   QuerySnapshot<Map<String, dynamic>> ledgers = await FirebaseFirestore
  //       .instance
  //       .collection('Ledgers')
  //       .where('members',
  //           arrayContains:
  //               doc)
  //       .get();
  //   double balance = 0;
  //   ledgers.docs.forEach((element) {
  //      element.collection()
  //         where(
  //             (element) => element.debtor == this || element.creditor == this)
  //         .forEach((element) {
  //       if (element.creditor == this) {
  //         balance += element.amount!;
  //       } else {
  //         balance -= element.amount!;
  //       }
  //     });
  //   });
  //   return balance;
  // }

  List<User> userListFromSnapshot(querySnapshot) {
    return querySnapshot.docs.map<User>((snapshot) {
      final Map<String, dynamic> dataMap = snapshot.data();

      return User.fromSnapshot(snapshot.id, dataMap);
    }).toList();
  }

  DocumentReference<Map<String, dynamic>> get docRef {
    return FirebaseFirestore.instance.collection("users").doc(uid);
  }

  static DocumentReference<Map<String, dynamic>> toDocRef(User user) {
    return FirebaseFirestore.instance.collection("users").doc(user.uid);
  }
}
