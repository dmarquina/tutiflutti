import 'package:scoped_model/scoped_model.dart';

mixin UserInputModel on Model {
  String userName = '';
  String gameWord = '';
  Map<String, Map<String, Map<String, String>>> userGameWordInputs = {};

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
    print(userGameWordInputs[userName][gameWord]);
    return userGameWordInputs[userName][gameWord][category];
  }
}
