import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nitkazez/models/ledger.dart';
import 'package:nitkazez/models/user.dart';
import 'package:nitkazez/providers/user_provider.dart';
import 'package:nitkazez/screens/modals/add_ledger_steps/second_step.dart';
import 'package:nitkazez/screens/modals/add_ledger_steps/first_step.dart';
import 'package:provider/provider.dart';

class CreateLedgerModal extends StatefulWidget {
  CreateLedgerModal({Key? key}) : super(key: key);

  @override
  _CreateLedgerModalState createState() => _CreateLedgerModalState();
}

class _CreateLedgerModalState extends State<CreateLedgerModal> {
  final _formsPageViewController = PageController();
  late List _forms;
  late Ledger _ledger;
  List<User> _members = [];
  String _ledgerName = "";

  @override
  Widget build(BuildContext context) {
    final userChange = Provider.of<UserProvider>(context);

    _forms = [
      WillPopScope(
        onWillPop: () => Future.sync(onWillPop),
        child: AddLedgerFirstStep(_members, _nextFormStep),
      ),
      WillPopScope(
        onWillPop: () => Future.sync(onWillPop),
        child: AddLedgerSecondStep(_submit),
      ),
    ];

    return Expanded(
      child: PageView.builder(
        controller: _formsPageViewController,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return _forms[index];
        },
      ),
    );
  }

  void _nextFormStep() {
    _formsPageViewController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _submit() {
    _ledger.members = _members.map((e) => e.docRef).toList();
    _ledger.createdAt = Timestamp.now();
    _ledger.ledgerName = _ledgerName;
    FirebaseFirestore.instance.collection("ledgers").add(_ledger.toMap());
  }

  bool onWillPop() {
    if (_formsPageViewController.page!.round() ==
        _formsPageViewController.initialPage) return true;

    _formsPageViewController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );

    return false;
  }
}
