import 'package:cloud_firestore/cloud_firestore.dart';

import 'Transaction.dart' as local;

class Ledger {
  List<DocumentReference<Map<String, dynamic>>> members;
  String ledgerName;
  List<local.Transaction> transactions;
  String creatorId;
  Timestamp createdAt;
  Ledger(this.ledgerName, this.members, this.transactions, this.createdAt,
      this.creatorId);
}
