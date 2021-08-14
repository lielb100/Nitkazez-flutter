import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../screens/ledger_screen.dart';

class LedgerList extends StatefulWidget {
  final String userName;
  final String uid;
  const LedgerList({Key? key, required this.userName, required this.uid})
      : super(key: key);

  @override
  _LedgerListState createState() => _LedgerListState();
}

class _LedgerListState extends State<LedgerList> {
  late DocumentReference<Map<String, dynamic>> ref;
  late Stream<QuerySnapshot> _ledgersStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    _ledgersStream = FirebaseFirestore.instance
        .collection("ledgers")
        .where('members', arrayContains: ref)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _ledgersStream,
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
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LedgerScreen(
                                ledger: document,
                              )));
                },
                title: Text(data['ledgerName']),
              );
            }).toList(),
          );
        });
  }
}
