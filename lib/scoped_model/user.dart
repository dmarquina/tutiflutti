import 'package:firebase_database/firebase_database.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/util/firebase_child_reference.dart';

mixin UserModel on Model {
  String _userId = '';
  String _username = '';

  final DatabaseReference userDatabase = FirebaseReference.getReference('user');

  setUserId(String userId) => this._userId = userId;

  setUsername(String userName) => this._username = userName;

  String get userId => _userId;

  String get username => _username;

  createUpdateUser(String username) async {
    this.setUsername(username);
    if (_userId != "" && _userId != '') {
      userDatabase.child(_userId).set({'username': username});
    } else {
      DatabaseReference newUser = userDatabase.push();
      newUser.set({'username': username});
      this.setUserId(newUser.key);
    }
  }
}
