import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nitkazez/models/Transaction.dart' as local;
import 'package:nitkazez/models/User.dart';
import 'package:nitkazez/providers/UserProvider.dart';
import 'package:provider/provider.dart';

class TransactionTile extends StatefulWidget {
  final local.Transaction transaction;

  const TransactionTile({Key? key, required local.Transaction this.transaction})
      : super(key: key);

  @override
  _TransactionTileState createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
  Future<List<User>> getCreditorAndDebitor(
      DocumentReference creditorRef, DocumentReference debtorRef) async {
    List<User> _creditorAndDebitor = [];
    _creditorAndDebitor.add(User.fromSnapshot(creditorRef.id,
        (await creditorRef.get()).data() as Map<String, dynamic>));
    _creditorAndDebitor.add(User.fromSnapshot(
        debtorRef.id, (await debtorRef.get()).data() as Map<String, dynamic>));
    return _creditorAndDebitor;
  }

  @override
  Widget build(BuildContext context) {
    final userChange = Provider.of<UserProvider>(context);
    return FutureBuilder<List<User>>(
      future: getCreditorAndDebitor(
          widget.transaction.creditor!, widget.transaction.debtor!),
      builder: (context, snapshot) {
        ListTile tile;
        if (snapshot.hasData) {
          User _creditor = snapshot.data![0];
          User _debtor = snapshot.data![1];
          String _creditorName = _creditor.uid == userChange.currentUser.uid
              ? 'you'
              : _creditor.userName;
          String _debtorName = _debtor.uid == userChange.currentUser.uid
              ? 'you'
              : _debtor.userName;
          tile = ListTile(
            title: Text(widget.transaction.transactionName!),
            subtitle: Text(
                "${widget.transaction.amount} ${widget.transaction.currency} from $_creditorName to $_debtorName"),
            trailing: IconButton(
              icon: Icon(Icons.edit_outlined),
              onPressed: () {
                debugPrint(widget.transaction.toString());
              },
            ),
          );
        } else if (snapshot.hasError) {
          tile = ListTile(
            title: Text('Error'),
            subtitle: Text('${snapshot.error}'),
          );
        } else {
          tile = ListTile(
            title: CircularProgressIndicator(),
          );
        }
        return tile;
      },
    );
  }
}
