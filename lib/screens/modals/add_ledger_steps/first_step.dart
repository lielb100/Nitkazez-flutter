import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/material.dart';
import 'package:nitkazez/models/user.dart';

class AddLedgerFirstStep extends StatefulWidget {
  void Function() nextFormStep;

  List<User> members;

  AddLedgerFirstStep(this.members, this.nextFormStep, {Key? key})
      : super(key: key);

  @override
  _AddLedgerFirstStepState createState() => _AddLedgerFirstStepState();
}

class _AddLedgerFirstStepState extends State<AddLedgerFirstStep> {
  List<User> selectedUsers = [];

  @override
  Widget build(BuildContext context) {
    return FirestoreSearchScaffold(
        firestoreCollectionName: 'users',
        searchBy: 'userName',
        limitOfRetrievedData: 4,
        scaffoldBody: Scaffold(
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                widget.members = selectedUsers;
                widget.nextFormStep();
              },
              child: const Icon(Icons.arrow_right)),
          body: ListView.builder(
            itemCount: selectedUsers.length,
            itemBuilder: (context, idx) => ListTile(
              title: Text(selectedUsers[idx].uid ?? ""),
              subtitle: Text(selectedUsers[idx].userName ?? ""),
            ),
          ),
        ),
        dataListFromSnapshot: User.fromObject().userListFromSnapshot,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<User> dataList = snapshot.data;

            return ListView.builder(
                itemCount: dataList?.length ?? 0,
                itemBuilder: (context, index) {
                  final User data = dataList[index];

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.userName ?? ''),
                      TextButton.icon(
                          onPressed: () {
                            setState(() {
                              selectedUsers.add(data);
                            });
                          },
                          icon: const Icon(Icons.person_add),
                          label: const Text("Add"))
                    ],
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
