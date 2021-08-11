import 'package:cloud_firestore/cloud_firestore.dart';

import 'Ledger.dart';

class User {
  String _uid;
  late String _userName;

  User(this._uid, this._userName) {}

  static Future<User> fromFireBase(String uid) async {
    var doc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    String username = doc.data()!["userName"];
    return new User(uid, username);
  }

  double get balance {
    List<Ledger> ledgers = FirebaseFirestore.instance
        .collection('Ledgers')
        .where('members', arrayContains: this) as List<Ledger>;
    double balance = 0;
    ledgers.forEach((element) {
      element.transactions
          .where(
              (element) => element.debtor == this || element.creditor == this)
          .forEach((element) {
        if (element.creditor == this) {
          balance += element.amount!;
        } else {
          balance -= element.amount!;
        }
      });
    });
    return balance;
  }

  set userName(String value) {
    this._userName = value;
  }

  set uid(String value) {
    this._uid = value;
  }

  String get uid => this._uid;
  String get userName => this._userName;
}
