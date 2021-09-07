import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nitkazez/components/search/firestore_search_component.dart';
import 'package:nitkazez/components/user_avatar.dart';
import 'package:nitkazez/models/user.dart';
import 'package:nitkazez/providers/ledger_members_provider.dart';
import 'package:nitkazez/providers/members_controller.dart';
import 'package:nitkazez/providers/user_provider.dart';
import 'package:nitkazez/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class AddLedgerFirstStep extends StatefulWidget {
  void Function() nextFormStep;

  AddLedgerFirstStep(this.nextFormStep, {Key? key}) : super(key: key);

  @override
  _AddLedgerFirstStepState createState() => _AddLedgerFirstStepState();
}

class _AddLedgerFirstStepState extends State<AddLedgerFirstStep> {
  List<User> selectedUsers = [];

  Widget _buildChip(String label, int index) {
    final color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    return CachedNetworkImage(
      imageUrl: "https://robohash.org/$label?bgset=bg1",
      imageBuilder: (context, imageProvider) => Chip(
        labelPadding: EdgeInsets.all(2.0),
        avatar: CircleAvatar(
          backgroundImage: imageProvider,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: color,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: EdgeInsets.all(8.0),
        deleteIcon: Icon(Icons.remove),
        onDeleted: () {
          setState(() {
            selectedUsers.removeAt(index);
          });
        },
      ),
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => CircleAvatar(
        child: Text(label[0].toUpperCase()),
        radius: 30,
      ),
    );
  }

  Widget chipsAppBottom(BuildContext context) {
    var s = selectedUsers.asMap();
    var chips = s
        .map((i, e) => MapEntry(i, _buildChip(e.userName!, i)))
        .values
        .toList();
    return Wrap(
      children: chips,
    );
    // return ListView.builder(
    //   scrollDirection: Axis.horizontal,

    //   itemCount: selectedUsers.length,
    //   itemBuilder: (context, index) {
    //     return _buildChip(selectedUsers[index].userName!, index);
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    final userChange = Provider.of<UserProvider>(context);
    // final ledgerMembersChange = Provider.of<LedgerMembersProvider>(context);
    MembersController membersController = Get.find();

    return FirestoreSearchScaffold(
      currentUserName: userChange.currentUser.userName!,
      appBarBottom: chipsAppBottom(context),
      firestoreCollectionName: 'users',
      searchBy: 'userName',
      // appBarBottom: chipsAppBottom(context),
      limitOfRetrievedData: 4,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            membersController.members = selectedUsers;
            widget.nextFormStep();
          },
          child: const Icon(Icons.arrow_right)),
      // scaffoldBody: Scaffold(
      //   body: ListView.builder(
      //     itemCount: selectedUsers.length,
      //     itemBuilder: (context, idx) => ListTile(
      //       title: Text(selectedUsers[idx].uid ?? ""),
      //       subtitle: Text(selectedUsers[idx].userName ?? ""),
      //     ),
      //   ),
      // ),
      dataListFromSnapshot: User.fromObject().userListFromSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<User> dataList = snapshot.data;

          return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10),
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final User data = dataList[index];
                bool flag = false;
                selectedUsers.forEach((element) {
                  if (element.uid == data.uid) flag = true;
                });
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                                  user: data,
                                )));
                  },
                  leading: UserAvatar(
                    userName: data.userName ?? "",
                    showUnderText: false,
                  ),
                  title: Text(data.userName ?? ""),
                  trailing: flag
                      ? TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.how_to_reg),
                          label: const Text("Added"),
                        )
                      : TextButton.icon(
                          onPressed: () {
                            setState(() {
                              selectedUsers.add(data);
                            });
                          },
                          icon: const Icon(Icons.person_add),
                          label: const Text("Add"),
                        ),
                );
                // return Column(
                //   mainAxisSize: MainAxisSize.min,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(data.userName ?? ''),
                //     TextButton.icon(
                //         onPressed: () {
                //           setState(() {
                //             selectedUsers.add(data);
                //           });
                //         },
                //         icon: const Icon(Icons.person_add),
                //         label: const Text("Add"))
                //   ],
                // );
              });
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      appBarTitle: 'Create Group',
    );
  }
}
