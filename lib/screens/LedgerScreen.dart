import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nitkazez/components/TransactionList.dart';
import 'package:nitkazez/models/Ledger.dart';
import 'package:nitkazez/screens/modals/CreateTransactionModal.dart';

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({Key? key, required this.ledger}) : super(key: key);
  final DocumentSnapshot ledger;
  @override
  _LedgerScreenState createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions"),
      ),
      body: TransactionList(
        ledgerRefrence: widget.ledger.reference,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => CreateTransactionModal(
                ledger: Ledger.fromSnapshot(widget.ledger.id,
                    widget.ledger.data() as Map<String, dynamic>),
              ),
              fullscreenDialog: true,
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
