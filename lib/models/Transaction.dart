import 'package:cloud_firestore/cloud_firestore.dart';

import 'User.dart';

class Transaction {
  DocumentReference<Map<String, dynamic>>? creditor;
  DocumentReference<Map<String, dynamic>>? debtor;
  double? amount;
  String? currency;
  String? transactionName;
  bool? isCreditorApprovedPaid;
  bool? isDebtorApprovedPaid;
  bool? isCreditorApprovedAdded;
  bool? isDebtorApprovedAdded;
  Timestamp? time;

  Transaction(
      this.creditor,
      this.debtor,
      this.amount,
      this.currency,
      this.isCreditorApprovedAdded,
      this.isCreditorApprovedPaid,
      this.isDebtorApprovedAdded,
      this.isDebtorApprovedPaid,
      this.time,
      this.transactionName);

  Transaction.empty();
}
