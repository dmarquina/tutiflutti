import 'dart:async';
import 'dart:convert';

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

  Future<bool> addUser(User user) async {
    Map<String, dynamic> newUserData = {
      'username': user.username,
      'score': user.score,
      'gameId': user.gameId
    };

    http.Response res = await http.post('http://localhost:8000/user',
        body: json.encode(newUserData), headers: {'Content-type': 'application/json'});
    if (res.statusCode != 200 && res.statusCode != 201) {
      _errorMessage = json.decode(res.body)['message'];
      return false;
    }else{
      return true;
    }
  }

  void getAllUsers() async {
    http.Response res = await http.get('http://localhost:8000/user');
    List<dynamic> userListData = json.decode(res.body);
    _users = userListData.map((dynamic userData) {
      String id = userData['_id'];
      String username = userData['username'];
      String gameId = userData['gameId'];
      return new User(username, id: id, gameId: gameId);
    }).toList();
    notifyListeners();
  }

  List<User> get allUsers => List.from(_users);

  String get errorMessage => _errorMessage;
}
