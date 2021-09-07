import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nitkazez/components/user_avatar.dart';
import 'package:nitkazez/models/user.dart';
import 'package:nitkazez/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final User? user;

  const ProfileScreen({Key? key, this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isInEditMode = false;
  String userName = '';
  late bool duplicate;
  String warning = '';
  Widget buildOwnProfile(BuildContext context) {
    final userChange = Provider.of<UserProvider>(context);
    // ignore: unused_local_variable
    bool isInEditMode = false;
    var balance2 = userChange.currentUser.balance;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: UserAvatar(
                      userName: userChange.currentUser.userName!,
                      radius: MediaQuery.of(context).size.width / 3,
                      showUnderText: false,
                    )),
                // const Text(
                //   "User Name:",
                //   style: TextStyle(fontSize: 20),
                // ),
                Text(
                  userChange.currentUser.userName ?? "",
                  style: const TextStyle(fontSize: 30),
                ),
                editMode(context),
                const Text(
                  "Balance:",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  balance2.toString(),
                  style: TextStyle(color: balanceColor(balance2), fontSize: 30),
                )
              ],
            ),
          ),
        ));
  }

  Color balanceColor(double balance) {
    if (balance > 0) {
      return Colors.green;
    }
    if (balance < 0) {
      return Colors.red;
    }
    return Colors.black;
  }

  Future<bool> isNameUnique(String userName) async {
    late bool check;
    var data = await FirebaseFirestore.instance
        .collection("users")
        .where("userName", isEqualTo: userName)
        .get()
        .catchError((error) {
      //TODO Remove in prod
      // ignore: avoid_print
      print("error: $error");
      check = false;
    });
    check = data.docs.isEmpty;
    // .then((value) => check = !(value.docs.length > 0))

    return check;
  }

  Widget editMode(BuildContext context) {
    final userChange = Provider.of<UserProvider>(context);
    final _formKey = GlobalKey<FormState>();
    if (isInEditMode) {
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              autocorrect: true,
              autofocus: false,
              enableInteractiveSelection: true,
              textCapitalization: TextCapitalization.words,
              onSaved: (value) {
                setState(() {
                  userName = value!.trim();
                });
              },
              decoration: const InputDecoration(labelText: "User Name"),
              validator: (value) {
                late String s;
                final validCharacters =
                    RegExp(r'^[a-zA-Z0-9]+( [a-zA-Z0-9]+)*$');
                if (value == null || value.trim().isEmpty) {
                  s = 'Please enter some text';
                  setState(() {
                    warning = s;
                  });
                  return s;
                } else {
                  final name = value.trim();
                  if (name.length < 6) {
                    s = 'User Name must be longer than six characters';
                    setState(() {
                      warning = s;
                    });
                    return s;
                  } else if (!validCharacters.hasMatch(name)) {
                    s = 'Alphanumeric characters only';
                    setState(() {
                      warning = s;
                    });
                    return s;
                  } else if (duplicate) {
                    s = 'This username is already taken';
                    setState(() {
                      warning = s;
                    });
                    return s;
                  }
                  return null;
                }
              },
            ),
            Row(
              children: [
                TextButton.icon(
                    onPressed: () async {
                      setState(() {
                        duplicate = false;
                      });
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (await isNameUnique(userName)) {
                          userChange.updateUserName(userName);
                          setState(() {
                            isInEditMode = false;
                            warning = "";
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Changed User Name!')));
                        } else {
                          setState(() {
                            duplicate = true;
                          });
                          _formKey.currentState!.validate();
                        }
                      }
                    },
                    icon: const Icon(Icons.save, color: Colors.green),
                    label: const Text("SAVE")),
                TextButton.icon(
                    onPressed: () {
                      setState(() {
                        isInEditMode = false;
                      });
                    },
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    label: const Text("CANCEL")),
              ],
            ),
            Center(
              child: warning.isNotEmpty
                  ? Text(warning,
                      style: const TextStyle(
                          color: Colors.red, fontStyle: FontStyle.italic))
                  : null,
            )
          ],
        ),
      );
    } else {
      return TextButton.icon(
        onPressed: () {
          setState(() {
            isInEditMode = true;
          });
        },
        label: const Text("EDIT"),
        icon: const Icon(Icons.edit),
      );
    }
  }

  Widget buildOtherProfile(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: UserAvatar(
                      userName: widget.user!.userName!,
                      radius: MediaQuery.of(context).size.width / 3,
                      showUnderText: false,
                    )),
                // const Text(
                //   "User Name:",
                //   style: TextStyle(fontSize: 20),
                // ),
                Text(
                  widget.user!.userName ?? "",
                  style: const TextStyle(fontSize: 30),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final userChange = Provider.of<UserProvider>(context);
    return widget.user == null || widget.user!.uid == userChange.currentUser.uid
        ? buildOwnProfile(context)
        : buildOtherProfile(context);
  }
}
