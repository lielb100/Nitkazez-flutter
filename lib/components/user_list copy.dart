import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nitkazez/components/user_avatar.dart';
import 'package:nitkazez/models/ledger.dart';
import 'package:nitkazez/models/user.dart' as local;
import 'package:nitkazez/providers/user_provider.dart';
import 'package:nitkazez/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key, required this.ledger}) : super(key: key);
  final Ledger ledger;
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  // ignore: unused_field
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _ledgerStream;

  Future<List<local.User>> docRefsToUserList(List<dynamic> members) async {
    return Future.wait(members.map((member) async {
      return local.User.fromSnapshot(
          member.id, (await member.get()).data() as Map<String, dynamic>);
    }).toList());
  }

  @override
  Widget build(BuildContext context) {
    final userChange = Provider.of<UserProvider>(context);
    var currentUserAdmin =
        widget.ledger.creatorId == userChange.currentUser.uid;
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _ledgerStream = FirebaseFirestore.instance
            .collection("ledgers")
            .doc(widget.ledger.ledgerId)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: const Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const Text("Loading"));
          }
          return FutureBuilder<List<local.User>>(
              future: docRefsToUserList(snapshot.data!["members"]),
              builder: (context, membersSnapshot) {
                if (membersSnapshot.hasData) {
                  var members = membersSnapshot.data!;
                  return Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: ListView.builder(
                          itemExtent: 150,
                          itemBuilder: (BuildContext context, int index) {
                            var member = members[index];
                            var admin = widget.ledger.creatorId == member.uid;
                            // return Container(
                            //   child: Text(member.userName!),
                            // );
                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileScreen(
                                              user: member,
                                            )));
                              },
                              trailing: admin
                                  ? null
                                  : currentUserAdmin
                                      ? TextButton.icon(
                                          onPressed: () {},
                                          icon: Icon(Icons.delete),
                                          label: const Text("Kick"))
                                      : null,
                              leading: UserAvatar(
                                userName: member.userName!,
                                showUnderText: false,
                              ),
                              title: Text(member.userName!),
                              subtitle: admin
                                  ? Center(
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Group Admin",
                                            style: TextStyle(
                                                color:
                                                    Colors.greenAccent[400]!),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color:
                                                    Colors.greenAccent[400]!),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                      ),
                                    )
                                  : Container(),
                            );
                          },
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              TextButton.icon(
                                  onPressed: () {},
                                  icon: currentUserAdmin
                                      ? Icon(Icons.delete)
                                      : Icon(Icons.logout),
                                  label: currentUserAdmin
                                      ? const Text("Delete Group")
                                      : const Text("Leave Group"))
                            ],
                          )),
                    ],
                  );
                } else if (membersSnapshot.hasError) {
                  return Center(
                    child: Text("ERORR"),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              });
        });
  }
}






// return SliverFixedExtentList(
//                       itemExtent: 150,
//                       delegate: SliverChildBuilderDelegate(
//                           (BuildContext context, int index) {
//                         var member = members[index];
//                         var admin = widget.ledger.creatorId == member.uid;
//                         final userChange = Provider.of<UserProvider>(context);
//                         var currentUserAdmin = widget.ledger.creatorId ==
//                             userChange.currentUser.uid;
//                         // return Container(
//                         //   child: Text(member.userName!),
//                         // );
//                         return ListTile(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => ProfileScreen(
//                                           user: member,
//                                         )));
//                           },
//                           // trailing: admin
//                           //     ? Container()
//                           //     : currentUserAdmin
//                           //         ? TextButton.icon(
//                           //             onPressed: () {},
//                           //             icon: Icon(Icons.delete),
//                           //             label: const Text("Kick"))
//                           //         : Container(),
//                           leading: UserAvatar(
//                             userName: member.userName!,
//                             showUnderText: false,
//                           ),
//                           title: Text(member.userName!),
//                           subtitle: admin
//                               ? Center(
//                                   child: Container(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Text(
//                                         "Group Admin",
//                                         style: TextStyle(
//                                             color: Colors.greenAccent[400]!),
//                                       ),
//                                     ),
//                                     decoration: BoxDecoration(
//                                         border: Border.all(
//                                             color: Colors.greenAccent[400]!),
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(20))),
//                                   ),
//                                 )
//                               : Container(),
//                         );
//                       }, childCount: members.length));