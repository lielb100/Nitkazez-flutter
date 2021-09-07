import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nitkazez/models/transaction.dart' as local;
import 'package:nitkazez/models/user.dart';
import 'package:nitkazez/providers/user_provider.dart';
import 'package:provider/provider.dart';

class PendingTransactionTile extends StatefulWidget {
  final local.Transaction transaction;

  const PendingTransactionTile({Key? key, required this.transaction})
      : super(key: key);

  @override
  _PendingTransactionTileState createState() => _PendingTransactionTileState();
}

class _PendingTransactionTileState extends State<PendingTransactionTile> {
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
        Widget tile;
        if (snapshot.hasData) {
          User _creditor = snapshot.data![0];

          User _debtor = snapshot.data![1];

          bool youCreditor;
          bool youDebtor;
          String? _creditorName;
          if (_creditor.uid == userChange.currentUser.uid) {
            _creditorName = 'you';
            youCreditor = true;
          } else {
            _creditorName = _creditor.userName;
            youCreditor = false;
          }

          String? _debtorName;
          if (_debtor.uid == userChange.currentUser.uid) {
            _debtorName = 'you';
            youDebtor = true;
          } else {
            _debtorName = _debtor.userName;
            youDebtor = false;
          }

          if (youDebtor) {
            tile = Slidable(
              actionPane: SlidableDrawerActionPane(),
              actions: [
                IconSlideAction(
                  caption: 'Completed',
                  color: Colors.green,
                  icon: Icons.delete,
                  onTap: () {},
                ),
              ],
              child: ListTile(
                title: Text(widget.transaction.transactionName!),
                subtitle: Text(
                    "you owe $_creditorName ${widget.transaction.amount} ${widget.transaction.currency}"),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {},
                ),
              ),
            );
          } else {
            if (youCreditor) {
              tile = Slidable(
                actionPane: SlidableDrawerActionPane(),
                actions: [],
                child: ListTile(
                  title: Text(widget.transaction.transactionName!),
                  subtitle: Text(
                      "$_debtorName owes you ${widget.transaction.amount} ${widget.transaction.currency}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {},
                  ),
                ),
              );
            } else {
              tile = ListTile(
                title: Text(widget.transaction.transactionName!),
                subtitle: Text(
                    "$_debtorName owes $_creditorName ${widget.transaction.amount} ${widget.transaction.currency}"),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {},
                ),
              );
            }
          }
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
