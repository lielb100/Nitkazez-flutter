import 'package:flutter/material.dart';
import 'package:nitkazez/models/ledger.dart';

class AddLedgerSecondStep extends StatefulWidget {
  const AddLedgerSecondStep(void Function() submit, {Key? key})
      : super(key: key);

  @override
  _AddLedgerSecondStepState createState() => _AddLedgerSecondStepState();
}

class _AddLedgerSecondStepState extends State<AddLedgerSecondStep> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //TODO add picture module and logic
          TextFormField(),
          TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.done),
              label: const Text("Create"))
        ],
      ),
    );
  }
}
