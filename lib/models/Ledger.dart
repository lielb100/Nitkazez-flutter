import 'package:cloud_firestore/cloud_firestore.dart';

import 'Transaction.dart' as local;

class Ledger {
  String _ledgerId;
  List<DocumentReference<Map<String, dynamic>>> _members;
  String _ledgerName;
  CollectionReference _transactions;
  String _creatorId;
  Timestamp _createdAt;
  Ledger(this._ledgerId, this._ledgerName, this._members, this._transactions,
      this._createdAt, this._creatorId);

  Ledger.fromSnapshot(String id, Map snapshot)
      : _ledgerId = id,
        _members = (snapshot['members'] as List<dynamic>)
            .map((e) => e as DocumentReference<Map<String, dynamic>>)
            .toList(),
        _ledgerName = snapshot['ledgerName'],
        _transactions = FirebaseFirestore.instance
            .collection("ledgers")
            .doc(id)
            .collection("transactions"),
        _creatorId = snapshot['creatorId'],
        _createdAt = snapshot["createdAt"];

  get members => this._members;
}
