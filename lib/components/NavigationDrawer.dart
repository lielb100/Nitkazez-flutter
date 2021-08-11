import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nitkazez/screens/InfoScreen.dart';
import 'package:nitkazez/screens/ProfileScreen.dart';
import 'package:nitkazez/screens/SettingsScreen.dart';

class NavigationDrawer extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final urlImage =
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80';
    return Drawer(
      child: Material(
        // color: Colors.tealAccent[700],
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlImage: urlImage,
              phoneNumber: _auth.currentUser!.phoneNumber,
              onClicked: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
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
        // child: ListView(
        //   padding: EdgeInsets.zero,
        //   children: [
        //     DrawerHeader(
        //       child: Text((_auth.currentUser!.phoneNumber?.toString())!),
        //       decoration: BoxDecoration(),
        //     ),
        //     ListTile(
        //       title: const Text("Profile"),
        //       onTap: () {},
        //     ),
        //     ListTile(
        //       title: const Text("Settings"),
        //     ),
        //   ],
        // ),
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
          builder: (context) => ProfileScreen(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SettingsScreen(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => InfoScreen(),
        ));
        break;
    }
  }

  buildHeader(
          {required String urlImage,
          required String? phoneNumber,
          required VoidCallback onClicked}) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
              SizedBox(
                width: 20,
              ),
              Text(
                phoneNumber!,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      );
}
