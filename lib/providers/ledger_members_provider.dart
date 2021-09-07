import 'package:flutter/foundation.dart';
import '../models/user.dart';

class LedgerMembersProvider extends ChangeNotifier {
  late List<User> _members;

  LedgerMembersProvider() {
    _members = [];
  }

  void removeByIndex(int idx) {
    _members.removeAt(idx);
    notifyListeners();
  }

  void addMember(User user) {
    _members.add(user);
    notifyListeners();
  }

  set members(List<User> users) {
    _members = users;
    notifyListeners();
  }

  List<User> get members => _members;

  void reset() {
    _members.clear();
    notifyListeners();
  }
}
