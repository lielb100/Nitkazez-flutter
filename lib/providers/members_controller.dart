import 'package:get/get.dart';
import 'package:nitkazez/models/user.dart';

class MembersController extends GetxController {
  MembersController();

  final _members = List<User>.empty().obs;
  set members(List<User> value) => this._members.value = value;
  List<User> get members => this._members.value;
}
