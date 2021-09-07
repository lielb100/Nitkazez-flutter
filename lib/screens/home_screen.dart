import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nitkazez/components/ledger_list.dart';
import 'package:nitkazez/providers/user_provider.dart';
import 'package:nitkazez/screens/login_screen.dart';
import 'package:nitkazez/components/navigation_drawer.dart';
import 'package:nitkazez/screens/modals/create_ledger_modal.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final userChange = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Groups"),
      ),
      drawer: NavigationDrawer(),
      body: LedgerList(
        userName: userChange.currentUser.userName!,
        uid: userChange.currentUser.uid!,
      ),
      floatingActionButton:
          //TODO fix settings logout and replace this with one add button
          Row(
        children: [
          const SizedBox(
            width: 40,
          ),
          ElevatedButton(
            onPressed: () async {
              _auth.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: const Icon(Icons.logout),
          ),
          const SizedBox(
            width: 10,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => CreateLedgerModal(),
                    fullscreenDialog: true,
                  ),
                );
              },
              child: Icon(Icons.add)),
        ],
      ),
    );
  }
}
