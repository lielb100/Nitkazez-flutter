import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart' as UserModel;

class UserProvider extends ChangeNotifier {
  late UserModel.User currentUser;

  UserProvider() {
    currentUser = UserModel.User("", "");
  }

  UserModel.User userFromFirebase(Map<String, dynamic> data, String uid) {
    return UserModel.User(uid, data["userName"]);
  }

  Future<bool> isUserExist(String uid) async {
    if (uid == "") return false;
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .catchError((error) => print("Failed to check user: $error"));
    if (documentSnapshot.exists) {
      return true;
    }
    return false;
  }

  int generateEightDigitNumber() {
    var rnd = Random();
    var next = rnd.nextDouble() * 100000000;
    while (next < 10000000) {
      next *= 10;
    }
    return next.toInt();
  }

  Future<UserModel.User> getCurrentUser(String uid) async {
    var userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .catchError((error) => print("Failed to get user: $error"));

    var user = userFromFirebase(userSnapshot.data()!, uid);
    return user;
  }

  Future<UserModel.User> createUser(String uid) async {
    String userName = 'user' + generateEightDigitNumber().toString();
    UserModel.User user = UserModel.User(uid, userName);
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'userName': userName,
    }).catchError((error) => print("Failed to add user: $error"));
    notifyListeners();
    return user;
  }

  Future<void> updateUserName(String userName) async {
    currentUser.userName = userName;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .update({'userName': userName}).catchError(
            (error) => print('Failed to update user: $error'));
    notifyListeners();
  }

  double get balance {
    double balance = currentUser.balance;
    return balance;
  }
}
