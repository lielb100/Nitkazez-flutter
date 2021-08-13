import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:nitkazez/models/Ledger.dart';
import 'package:nitkazez/models/Transaction.dart' as local;
import 'package:nitkazez/providers/UserProvider.dart';
import 'package:provider/provider.dart';

class CreateTransactionModal extends StatefulWidget {
  final Ledger ledger;

  const CreateTransactionModal({Key? key, required this.ledger})
      : super(key: key);

  @override
  _CreateTransactionModalState createState() => _CreateTransactionModalState();
}

class _CreateTransactionModalState extends State<CreateTransactionModal> {
  final _formkey = GlobalKey<FormBuilderState>();
  bool _enableDropDown = false;

  late local.Transaction transaction = local.Transaction.empty();
  final List<String> currencies = ["ILS", "USD", "GBP", "AUS"];
  @override
  Widget build(BuildContext context) {
    final userChange = Provider.of<UserProvider>(context);
    final userRef = FirebaseFirestore.instance
        .collection("users")
        .doc(userChange.currentUser.uid);
    // List<DropdownMenuItem> _allOtherUsers = widget.ledger.members
    //     .where((element) => element != userRef)
    //     .map((DocumentReference<Map<String, dynamic>> e) =>
    //         FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    //             future: e.get(),
    //             builder: (context, snapshot) {
    //               return snapshot.hasData
    //                   ? DropdownMenuItem(
    //                       value: e,
    //                       child: Text(snapshot.data!.data()!["userName"]),
    //                     )
    //                   : DropdownMenuItem(
    //                       value: e,
    //                       child: CircularProgressIndicator(),
    //                     );
    //             }) as DropdownMenuItem<DocumentSnapshot<Map<String, dynamic>>>)
    //     .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Add a transaction"),
      ),
      body: Column(
        children: [
          FormBuilder(
            key: _formkey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: "Name",
                  decoration: InputDecoration(labelText: "Name of transaction"),
                  onChanged: (value) {
                    setState(() {
                      transaction.transactionName = value ?? "";
                    });
                  },
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                    FormBuilderValidators.minLength(context, 6),
                    FormBuilderValidators.maxLength(context, 50),
                  ]),
                ),
                FormBuilderTextField(
                  name: "amount",
                  decoration: InputDecoration(labelText: "Amount of money"),
                  onSaved: (value) {
                    setState(() {
                      if (value != "") {
                        transaction.amount = double.parse(value!);
                      }
                    });
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.numeric(context),
                    FormBuilderValidators.max(context, 99999),
                    FormBuilderValidators.minLength(context, 1),
                    FormBuilderValidators.min(context, 1),
                  ]),
                  keyboardType: TextInputType.number,
                ),
                FormBuilderDropdown(
                  name: "currency",
                  decoration: InputDecoration(labelText: "Currency"),
                  allowClear: false,
                  items: currencies
                      .map((currency) => DropdownMenuItem(
                            value: currency,
                            child: Text('$currency'),
                          ))
                      .toList(),
                ),
                FormBuilderDateTimePicker(
                  name: "time",
                  inputType: InputType.both,
                  decoration: InputDecoration(labelText: "Date and Time"),
                  initialDate: DateTime.now(),
                  initialTime: TimeOfDay.now(),
                  firstDate: DateTime.now().subtract(Duration(days: 365)),
                  lastDate: DateTime.now(),
                  onSaved: (value) {
                    setState(() {
                      Timestamp.fromDate(value!);
                    });
                  },
                ),
                // FormBuilderDropdown(
                //   name: "creditor/debtor",
                //   validator: FormBuilderValidators.compose([
                //     FormBuilderValidators.required(context),
                //   ]),
                //   decoration: InputDecoration(
                //       labelText: transaction.creditor == userRef
                //           ? "Debtor"
                //           : "Creditor"),
                //   allowClear: false,
                //   enabled: this._enableDropDown ? true : false,
                //   items: _allOtherUsers,
                // ),
                FormBuilderSwitch(
                  name: "debtor or creditor",
                  title: Text("Are you the creditor or the debtor?"),
                  initialValue: true,
                  onChanged: (value) {
                    setState(() {
                      this._enableDropDown = true;
                      var you = FirebaseFirestore.instance
                          .collection('users')
                          .doc(userChange.currentUser.uid);
                      value!
                          ? transaction.creditor = you
                          : transaction.debtor = you;
                    });
                  },
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    if (_formkey.currentState?.saveAndValidate() ?? false) {
                      print(_formkey.currentState?.value);
                    } else {
                      print(_formkey.currentState?.value);
                      print('validation failed');
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _formkey.currentState?.reset();
                  },
                  // color: Theme.of(context).colorScheme.secondary,
                  child: Text(
                    'Reset',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
