import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nitkazez/components/user_avatar.dart';
import 'package:nitkazez/providers/user_provider.dart';
import 'package:nitkazez/screens/info_screen.dart';
import 'package:nitkazez/screens/profile_screen.dart';
import 'package:nitkazez/screens/settings_screen.dart';
import 'package:provider/provider.dart';

class NavigationDrawer extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final userChange = Provider.of<UserProvider>(context);

    return Drawer(
      child: Material(
        // color: Colors.tealAccent[700],
        child: ListView(
          children: <Widget>[
            buildHeader(
              userName: userChange.currentUser.userName!,
              onClicked: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              ),
            ),
            const SizedBox(
              height: 48,
            ),
            buildMenuItem(
              text: "Settings",
              icon: Icons.settings,
              onClicked: () => selectedItem(context, 1),
            ),
            const SizedBox(
              height: 48,
            ),
            buildMenuItem(
              text: "Info",
              icon: Icons.info,
              onClicked: () => selectedItem(context, 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SettingsScreen(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const InfoScreen(),
        ));
        break;
    }
  }

  buildHeader({required String userName, required VoidCallback onClicked}) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(const EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              UserAvatar(
                userName: userName,
                radius: 40.0,
                showUnderText: false,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                userName,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      );
}
