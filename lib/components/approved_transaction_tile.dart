import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nitkazez/models/transaction.dart' as local;
import 'package:nitkazez/models/user.dart';
import 'package:nitkazez/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ApprovedTransactionTile extends StatefulWidget {
  final local.Transaction transaction;

  const ApprovedTransactionTile({Key? key, required this.transaction})
      : super(key: key);

  @override
  _ApprovedTransactionTileState createState() =>
      _ApprovedTransactionTileState();
}

class _ApprovedTransactionTileState extends State<ApprovedTransactionTile> {
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
    Color bgTile = Colors.white;
    final userChange = Provider.of<UserProvider>(context);
    return FutureBuilder<List<User>>(
      future: getCreditorAndDebitor(
          widget.transaction.creditor!, widget.transaction.debtor!),
      builder: (context, snapshot) {
        Widget tile;
        if (snapshot.hasData) {
          User _creditor = snapshot.data![0];

          User _debtor = snapshot.data![1];

          String? _creditorName;
          if (_creditor.uid == userChange.currentUser.uid) {
            _creditorName = 'you';
            bgTile = Colors.green[200]!;
          } else {
            _creditorName = _creditor.userName;
          }

          String? _debtorName;
          if (_debtor.uid == userChange.currentUser.uid) {
            _debtorName = 'you';
            bgTile = Colors.redAccent[100]!;
          } else {
            _debtorName = _debtor.userName;
          }

          tile = ListTile(
            title: Text(widget.transaction.transactionName!),
            subtitle: Text(
                "$_debtorName owes $_creditorName ${widget.transaction.amount} ${widget.transaction.currency}"),
            trailing: IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                debugPrint(widget.transaction.toString());
              },
            ),
          );
          tile = Container(
            child: tile,
            decoration: BoxDecoration(color: bgTile),
          );
        } else if (snapshot.hasError) {
          tile = ListTile(
            title: const Text('Error'),
            subtitle: Text('${snapshot.error}'),
          );
        } else {
          tile = const ListTile(
            title: CircularProgressIndicator(),
          );
        }
        return tile;
      },
    );
  }
}
