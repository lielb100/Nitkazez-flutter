import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nitkazez/models/User.dart';
import 'package:nitkazez/providers/UserProvider.dart';
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
    bool isInEditMode = false;
    return Scaffold(
        appBar: AppBar(
          title: Text("Info"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  userChange.currentUser.userName,
                  style: TextStyle(fontSize: 30),
                ),
                editMode(context),
                Text("Balance:"),
                Text(widget.user!.balance.toString())
              ],
            ),
          ),
        ));
  }

  Future<bool> isNameUnique(String userName) async {
    late bool check;
    var data = await FirebaseFirestore.instance
        .collection("users")
        .where("userName", isEqualTo: userName)
        .get()
        .catchError((error) {
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
              decoration: InputDecoration(labelText: "User Name"),
              validator: (value) {
                late String s;
                final validCharacters =
                    RegExp(r'^[a-zA-Z0-9]+( [a-zA-Z0-9]+)*$');
                if (value == null || value.trim().isEmpty) {
                  s = 'Please enter some text';
                  setState(() {
                    this.warning = s;
                  });
                  return s;
                } else {
                  final name = value.trim();
                  if (name.length < 6) {
                    s = 'User Name must be longer than six characters';
                    setState(() {
                      this.warning = s;
                    });
                    return s;
                  } else if (!validCharacters.hasMatch(name)) {
                    s = 'Alphanumeric characters only';
                    setState(() {
                      this.warning = s;
                    });
                    return s;
                  } else if (duplicate) {
                    s = 'This username is already taken';
                    setState(() {
                      this.warning = s;
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
                        if (await this.isNameUnique(this.userName)) {
                          userChange.updateUserName(this.userName);
                          setState(() {
                            this.isInEditMode = false;
                            this.warning = "";
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
                    icon: Icon(Icons.save, color: Colors.green),
                    label: Text("SAVE")),
                TextButton.icon(
                    onPressed: () {
                      setState(() {
                        isInEditMode = false;
                      });
                    },
                    icon: Icon(Icons.cancel, color: Colors.red),
                    label: Text("CANCEL")),
              ],
            ),
            Center(
              child: this.warning.isNotEmpty
                  ? Text(this.warning,
                      style: TextStyle(
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
        label: Text("EDIT"),
        icon: Icon(Icons.edit),
      );
    }
  }

  Widget buildOtherProfile(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Info"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Balance:"), Text(widget.user!.balance.toString())],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return widget.user == null
        ? buildOwnProfile(context)
        : buildOtherProfile(context);
  }
}
