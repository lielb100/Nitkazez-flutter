import 'package:cloud_firestore/cloud_firestore.dart';

import 'Ledger.dart';

class User {
  String _uid;
  String _userName;

  User(this._uid, this._userName) {}

  User.fromSnapshot(String id, Map<String, dynamic> snapshot)
      : _uid = id,
        _userName = snapshot['userName'];

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

  set userName(String value) {
    this._userName = value;
  }

  set uid(String value) {
    this._uid = value;
  }

  String get uid => this._uid;
  String get userName => this._userName;

  static DocumentReference<Map<String, dynamic>> toDocRef(User user) {
    return FirebaseFirestore.instance.collection("users").doc(user._uid);
  }
}
