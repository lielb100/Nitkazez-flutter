import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nitkazez/models/User.dart' as UserModel;
import 'package:nitkazez/providers/UserProvider.dart';
import 'package:nitkazez/providers/DarkThemeProvider.dart';
import 'package:provider/provider.dart';

import 'LoginScreen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final userChange = Provider.of<UserProvider>(context);
    var _auth = FirebaseAuth.instance;
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 48,
            ),
            ListTile(
              leading: Icon(Icons.brush),
              title: Text("Theme"),
              onTap: () => themeChange.darkTheme = !themeChange.darkTheme,
              trailing: Switch(
                onChanged: (bool value) {
                  themeChange.darkTheme = value;
                },
                value: themeChange.darkTheme,
              ),
            ),
            const SizedBox(
              height: 48,
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () async {
                userChange.currentUser = UserModel.User("", "");
                _auth.signOut();
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            )
          ],
        ));
    ;
  }
}
