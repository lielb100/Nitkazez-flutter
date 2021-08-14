import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:nitkazez/models/ledger.dart';
import 'package:nitkazez/models/transaction.dart' as local;
import 'package:nitkazez/providers/user_provider.dart';
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

  late local.Transaction transaction = local.Transaction.empty();
  final List<String> currencies = ["ILS", "USD", "GBP", "AUS"];

  String creditorDebtorLabel = "";
  @override
  Widget build(BuildContext context) {
    final userChange = Provider.of<UserProvider>(context);
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

    DocumentReference<Map<String, dynamic>> userRef() =>
        FirebaseFirestore.instance
            .collection("users")
            .doc(userChange.currentUser.uid);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a transaction"),
      ),
      body: Column(
        children: [
          FormBuilder(
            key: _formkey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: "name",
                  decoration:
                      const InputDecoration(labelText: "Name of transaction"),
                  onSaved: (value) {
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
                  decoration:
                      const InputDecoration(labelText: "Amount of money"),
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
                  decoration: const InputDecoration(labelText: "Currency"),
                  allowClear: false,
                  items: currencies
                      .map((currency) => DropdownMenuItem(
                            value: currency,
                            child: Text(currency),
                          ))
                      .toList(),
                ),
                FormBuilderDateTimePicker(
                  name: "time",
                  inputType: InputType.both,
                  decoration: const InputDecoration(labelText: "Date and Time"),
                  initialDate: DateTime.now(),
                  initialTime: TimeOfDay.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now(),
                  onSaved: (value) {
                    setState(() {
                      Timestamp.fromDate(value!);
                    });
                  },
                ),
                FormBuilderRadioGroup<String>(
                  name: "Creditor/Debtor switch",
                  initialValue: null,
                  decoration: const InputDecoration(
                      labelText: "Are you the creditor or the debtor?"),
                  options: const ["Creditor", "Debtor"]
                      .map((val) => FormBuilderFieldOption(
                            value: val,
                            child: Text(val),
                          ))
                      .toList(growable: false),
                  onChanged: (value) {
                    setState(() {
                      switch (value) {
                        case null:
                          creditorDebtorLabel = "";
                          break;
                        case "Creditor":
                          transaction.creditor = userRef();
                          creditorDebtorLabel = "Creditor";
                          break;
                        default:
                          transaction.debtor = userRef();
                          creditorDebtorLabel = "Debtor";
                      }
                    });
                  },
                  separator: const VerticalDivider(
                    width: 10,
                    thickness: 5,
                  ),
                ),
                if (creditorDebtorLabel != "")
                  FormBuilderDropdown(
                    name: "creditor/debtor",
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                    ]),
                    decoration: InputDecoration(labelText: creditorDebtorLabel),
                    allowClear: false,
                    // ignore: prefer_const_literals_to_create_immutables
                    items: /*_allOtherUsers*/ [
                      const DropdownMenuItem(child: Text("test"))
                    ],
                  ),

                // FormBuilderSwitch(
                //   name: "debtor or creditor",
                //   title: const Text("Are you the creditor or the debtor?"),
                //   initialValue: true,
                //   onChanged: (value) {
                //     setState(() {
                //       value!
                //           ? transaction.creditor = userRef
                //           : transaction.debtor = userRef;
                //     });
                //   },
                // ),
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
                      transaction.createdAt = Timestamp.now();
                      transaction.amount =
                          _formkey.currentState?.value["amount"];
                      transaction.currency =
                          _formkey.currentState?.value["currency"];
                      transaction.time = _formkey.currentState?.value["time"];
                      transaction.transactionName =
                          _formkey.currentState?.value["name"];
                      if (creditorDebtorLabel == "Creditor") {
                        transaction.isCreditorApprovedAdded = true;
                        transaction.debtor =
                            _formkey.currentState?.value["creditor/debtor"];
                      } else {
                        transaction.isDebtorApprovedAdded = true;
                        transaction.creditor =
                            _formkey.currentState?.value["creditor/debtor"];
                      }
                      FirebaseFirestore.instance
                          .collection("ledgers")
                          .doc(widget.ledger.ledgerId)
                          .collection("transactions")
                          .add(transaction.toMap());
                      //TODO Remove in prod
                      // ignore: avoid_print
                      print(_formkey.currentState?.value);
                    } else {
                      //TODO Remove in prod
                      // ignore: avoid_print
                      print(_formkey.currentState?.value);
                      //TODO Remove in prod
                      // ignore: avoid_print
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
                    setState(() {
                      creditorDebtorLabel = "";
                    });
                  },
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
