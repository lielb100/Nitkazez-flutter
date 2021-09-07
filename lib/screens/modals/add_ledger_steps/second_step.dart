import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:nitkazez/components/user_avatar.dart';
// import 'package:nitkazez/providers/ledger_members_provider.dart';
import 'package:nitkazez/providers/members_controller.dart';
// import 'package:provider/provider.dart';

class AddLedgerSecondStep extends StatefulWidget {
  Future<String> Function(String) submit;

  AddLedgerSecondStep(this.submit, {Key? key}) : super(key: key);

  @override
  _AddLedgerSecondStepState createState() => _AddLedgerSecondStepState();
}

class _AddLedgerSecondStepState extends State<AddLedgerSecondStep> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    // List<Widget> users = widget.users
    //     .map<Widget>((user) => UserAvatar(userName: user.userName ?? ""))
    //     .toList();
    // final ledgerMembersChange = Provider.of<LedgerMembersProvider>(context);
    MembersController membersController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Group"),
      ),
      body: Column(
        children: [
          //TODO add picture module and logic
          Expanded(
            flex: 1,
            child: const Text(
              "Add Subject:",
              style: TextStyle(fontSize: 30),
            ),
          ),
          Expanded(
            flex: 2,
            child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: "name",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.minLength(context, 2),
                        FormBuilderValidators.maxLength(context, 24),
                        FormBuilderValidators.match(
                            context, r'^[a-zA-Z0-9]+( [a-zA-Z0-9]+)*$')
                      ]),
                    )
                  ],
                )),
          ),
          Expanded(
            flex: 1,
            child: TextButton.icon(
                onPressed: () async {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    String error = await widget
                        .submit(_formKey.currentState?.value["name"]);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text((error))));
                  }
                },
                icon: const Icon(Icons.done),
                label: const Text("Create")),
          ),
          Spacer(),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              height: MediaQuery.of(context).size.height * 0.35,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: membersController.members.length,
                itemBuilder: (context, index) {
                  return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: UserAvatar(
                      userName: membersController.members[index].userName!,
                      radius: 30,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
        //TODO Add participants
      ),
    );
  }
}
