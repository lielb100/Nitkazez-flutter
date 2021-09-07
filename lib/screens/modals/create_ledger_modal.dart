import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nitkazez/models/ledger.dart';
import 'package:nitkazez/models/user.dart';
import 'package:nitkazez/providers/members_controller.dart';
import 'package:nitkazez/providers/user_provider.dart';
import 'package:nitkazez/screens/modals/add_ledger_steps/second_step.dart';
import 'package:nitkazez/screens/modals/add_ledger_steps/first_step.dart';
import 'package:provider/provider.dart';

import '../ledger_screen.dart';

class CreateLedgerModal extends StatefulWidget {
  CreateLedgerModal({Key? key}) : super(key: key);

  @override
  _CreateLedgerModalState createState() => _CreateLedgerModalState();
}

class _CreateLedgerModalState extends State<CreateLedgerModal> {
  final _formsPageViewController = PageController();
  late List _forms;
  late Ledger _ledger;
  // LedgerMembersProvider ledgerMembersProvider = LedgerMembersProvider();
  MembersController membersController = Get.put(MembersController());

  @override
  Widget build(BuildContext context) {
    _forms = [
      WillPopScope(
        onWillPop: () => Future.sync(onWillPop),
        child: AddLedgerFirstStep(_nextFormStep),
      ),
      WillPopScope(
        onWillPop: () => Future.sync(onWillPop),
        child: AddLedgerSecondStep(_submit),
      ),
    ];

    return PageView.builder(
      controller: _formsPageViewController,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return _forms[index];
      },
    );
  }

  void _nextFormStep() {
    _formsPageViewController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  Future<String> _submit(String name) async {
    final userChange = Provider.of<UserProvider>(context, listen: false);
    MembersController membersController = Get.find();

    membersController.members.add(userChange.currentUser);
    _ledger = Ledger.create(
        name,
        membersController.members.map((User user) => user.docRef).toList(),
        Timestamp.now(),
        userChange.currentUser.uid!);
    var returnVal;
    await FirebaseFirestore.instance
        .collection("ledgers")
        .add(_ledger.toMap())
        .then((value) {
      returnVal = value.id;
      _ledger.ledgerId = value.id;
      _formsPageViewController.dispose();
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LedgerScreen(
                    ledger: _ledger,
                  )));
    }).catchError((error, stackTrace) {
      returnVal = error.toString();
    });
    return returnVal;
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
