import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nitkazez/models/user.dart' as user_model;
import 'package:nitkazez/providers/user_provider.dart';
import 'package:nitkazez/providers/dark_theme_provider.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final userChange = Provider.of<UserProvider>(context);
    var _auth = FirebaseAuth.instance;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 48,
            ),
            ListTile(
              leading: const Icon(Icons.brush),
              title: const Text("Theme"),
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
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                userChange.currentUser = user_model.User("", "");
                _auth.signOut();
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            )
          ],
        ));
  }
}
