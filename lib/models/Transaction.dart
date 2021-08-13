import 'package:cloud_firestore/cloud_firestore.dart';

import 'User.dart';

class Transaction {
  String? _transactionId;
  DocumentReference<Map<String, dynamic>>? _creditor;
  DocumentReference<Map<String, dynamic>>? _debtor;
  double? _amount;
  String? _currency;
  String? _transactionName;
  bool? _isCreditorApprovedPaid;
  bool? _isDebtorApprovedPaid;
  bool? _isCreditorApprovedAdded;
  bool? _isDebtorApprovedAdded;
  Timestamp? _time;
  Timestamp? _createdAt;

  Transaction.fromSnapshot(String id, Map<String, dynamic> snapshot)
      : _transactionId = id,
        _creditor = snapshot['creditor'],
        _debtor = snapshot['debtor'],
        _amount = (snapshot['amount'] as int).toDouble(),
        _currency = snapshot['currency'],
        _transactionName = snapshot["transactionName"],
        _isCreditorApprovedAdded = snapshot["isCreditorApprovedAdded"],
        _isDebtorApprovedAdded = snapshot["isDebtorApprovedAdded"],
        _isCreditorApprovedPaid = snapshot["isCreditorApprovedPaid"],
        _isDebtorApprovedPaid = snapshot["isDebtorApprovedPaid"],
        _time = snapshot["time"],
        _createdAt = snapshot["createdAt"];
  Transaction(
      this._transactionId,
      this._creditor,
      this._debtor,
      this._amount,
      this._currency,
      this._isCreditorApprovedAdded,
      this._isCreditorApprovedPaid,
      this._isDebtorApprovedAdded,
      this._isDebtorApprovedPaid,
      this._time,
      this._createdAt,
      this._transactionName);

  Transaction.empty();

  DocumentReference<Map<String, dynamic>>? get creditor => _creditor;

  String? get currency => this._currency;

  double? get amount => this._amount;

  String? get transactionName => this._transactionName;

  DocumentReference<Map<String, dynamic>>? get debtor => _debtor;

  set transactionName(String? transactionName) {}

  set amount(double? amount) {}

  set debtor(DocumentReference<Map<String, dynamic>>? debtor) {}

  set creditor(DocumentReference<Map<String, dynamic>>? creditor) {}
}
