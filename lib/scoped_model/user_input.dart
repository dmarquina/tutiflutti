import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:tutiflutti/model/user_input.dart';

mixin UserInputModel on Model {
  String userName = '';
  String gameWord = '';
  String _errorMessage = '';
  List<User> _users = [];
  Map<String, Map<String, Map<String, String>>> userGameWordInputs = {};
  int totalScore = 0;

  final DatabaseReference userDatabase = FirebaseDatabase.instance.reference().child('user');

  setUserName(String userName) {
    this.userName = userName;
    userGameWordInputs[userName] = {};
  }

  setGameWord(String gameWord) {
    if (this.userName != '') {
      this.gameWord = gameWord;
      userGameWordInputs[userName][gameWord] = {};
    } else {
      throw ('Ingresa username primero');
    }
  }

  void addUserInput(String category, String inputValue) {
    userGameWordInputs[userName][gameWord][category] = inputValue;
  }

  String getUserInput(String category) {
    return userGameWordInputs[userName][gameWord][category];
  }

  Map<String, String> getUserCategoryInputs() {
    return userGameWordInputs[userName][gameWord];
  }

  Map<String, String> getUserCategoryInputsNotEmpty() {
    Map<String, String> inputsNotEmpty = {};
    userGameWordInputs[userName][gameWord].forEach((key, value) {
      if (value.isNotEmpty) {
        inputsNotEmpty.addAll({key: value});
      }
    });

    return inputsNotEmpty;
  }

  void addUser(User user) async{
    Map<String, dynamic> newUserData = {
      'username': user.username,
      'score': user.score,
      'gameId': user.gameId
    };
    await userDatabase.push().set(newUserData).then((res) {}, onError: (error) {
      print(error);
    });
  }

  DatabaseReference getAllUsers() {
     return userDatabase;
  }

  List<User> get allUsers => List.from(_users);

  String get errorMessage => _errorMessage;
}
