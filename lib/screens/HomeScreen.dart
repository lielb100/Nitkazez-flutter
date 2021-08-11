import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nitkazez/components/LedgerList.dart';
import 'package:nitkazez/providers/UserProvider.dart';
import 'package:nitkazez/screens/LoginScreen.dart';
import 'package:nitkazez/components/NavigationDrawer.dart';
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
        title: Text("Groups"),
      ),
      drawer: NavigationDrawer(),
      body: LedgerList(
        userName: userChange.currentUser.userName,
        uid: userChange.currentUser.uid,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _auth.signOut();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        },
        child: Icon(Icons.logout),
      ),
    );
  }
}
