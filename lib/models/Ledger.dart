import 'package:cloud_firestore/cloud_firestore.dart'
    show CollectionReference, DocumentReference, FirebaseFirestore, Timestamp;

class Ledger {
  late String ledgerId;
  late List<DocumentReference<Map<String, dynamic>>> members;
  late String ledgerName;
  late CollectionReference transactions;
  late String creatorId;
  late Timestamp createdAt;
  Ledger(this.ledgerId, this.ledgerName, this.members, this.transactions,
      this.createdAt, this.creatorId);
  Ledger.create(this.ledgerName, this.members, this.createdAt, this.creatorId);
  Ledger.fromSnapshot(String id, Map snapshot)
      : ledgerId = id,
        members = (snapshot['members'] as List<dynamic>)
            .map((e) => e as DocumentReference<Map<String, dynamic>>)
            .toList(),
        ledgerName = snapshot['ledgerName'],
        transactions = FirebaseFirestore.instance
            .collection("ledgers")
            .doc(id)
            .collection("transactions"),
        creatorId = snapshot['creatorId'],
        createdAt = snapshot["createdAt"];

  Map<String, dynamic> toMap() => {
        "createdAt": createdAt,
        "creatorId": creatorId,
        "ledgerName": ledgerName,
        "members": members,
      };
}
