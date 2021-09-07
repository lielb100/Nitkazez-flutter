import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  String? transactionId;
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
  Timestamp? createdAt;

  Transaction.fromSnapshot(String id, Map<String, dynamic> snapshot)
      : transactionId = id,
        creditor = snapshot['creditor'],
        debtor = snapshot['debtor'],
        amount = (snapshot['amount'] as int).toDouble(),
        currency = snapshot['currency'],
        transactionName = snapshot["transactionName"],
        isCreditorApprovedAdded = snapshot["isCreditorApprovedAdded"],
        isDebtorApprovedAdded = snapshot["isDebtorApprovedAdded"],
        isCreditorApprovedPaid = snapshot["isCreditorApprovedPaid"],
        isDebtorApprovedPaid = snapshot["isDebtorApprovedPaid"],
        time = snapshot["time"],
        createdAt = snapshot["createdAt"];
  Transaction(
      this.transactionId,
      this.creditor,
      this.debtor,
      this.amount,
      this.currency,
      this.isCreditorApprovedAdded,
      this.isCreditorApprovedPaid,
      this.isDebtorApprovedAdded,
      this.isDebtorApprovedPaid,
      this.time,
      this.createdAt,
      this.transactionName);

  Map<String, dynamic> toMap() => {
        "amount": amount,
        "createdAt": createdAt,
        "creditor": creditor,
        "currency": currency,
        "debtor": debtor,
        "isCreditorApprovedAdded": isCreditorApprovedAdded,
        "isCreditorApprovedPaid": isCreditorApprovedPaid,
        "isDebtorApprovedAdded": isDebtorApprovedAdded,
        "isDebtorApprovedPaid": isDebtorApprovedPaid,
        "time": time,
        "transactionName": transactionName
      };
  Transaction.empty() {
    isCreditorApprovedPaid = false;
    isDebtorApprovedPaid = false;
    isDebtorApprovedAdded = false;
    isCreditorApprovedAdded = false;
  }

  bool get completed {
    return isDebtorApprovedPaid! && isCreditorApprovedPaid! ? true : false;
  }

  bool get Approved {
    return isDebtorApprovedAdded! && isCreditorApprovedAdded! ? true : false;
  }
}
