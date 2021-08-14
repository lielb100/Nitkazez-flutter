import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nitkazez/components/transaction_tile.dart';
import '../models/transaction.dart' as local;

class TransactionList extends StatefulWidget {
  const TransactionList({Key? key, required this.ledgerRefrence})
      : super(key: key);
  final DocumentReference ledgerRefrence;
  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  // ignore: unused_field
  late Stream<QuerySnapshot> _transactionsStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _transactionsStream = widget.ledgerRefrence
            .collection("transactions")
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return TransactionTile(
                  transaction:
                      local.Transaction.fromSnapshot(document.id, data));
            }).toList(),

            /*           children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String yourUid = userChange.currentUser.uid;
              DocumentReference<Map<String, dynamic>> creditorRef =
                  data["creditor"];
              late String creditorName;
              creditorRef.path.split('/')[1] == yourUid
                  ? creditorName = "You"
                  : creditorRef.get().then(
                      (value) => creditorName = value.data()!["userName"]);
              DocumentReference<Map<String, dynamic>> debtorRef =
                  data["debtor"];
              String debtorName = "";
              debtorRef.path.split('/')[1] == yourUid
                  ? debtorName = "You"
                  : debtorRef
                      .get()
                      .then((value) => debtorName = value.data()!["userName"]);
              return ListTile(
                title: Text(data['transactionName']),
                subtitle: Text(
                    "${data["amount"]} ${data["currency"]} from $creditorName to $debtorName"),
                trailing: IconButton(
                  icon: Icon(Icons.edit_outlined),
                  onPressed: () {
                    debugPrint(data.toString());
                  },
                ),
              );
            }).toList(),*/
          );
        });
  }
}