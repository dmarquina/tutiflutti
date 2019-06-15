import 'package:firebase_database/firebase_database.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/model/user_input.dart';
import 'package:tutiflutti/util/constants.dart';
import 'package:tutiflutti/util/firebase_child_reference.dart';

mixin UserInputModel on Model {
  Map<String, String> _userInputs = {};

  addUserInput(String category, String inputValue) => _userInputs[category] = inputValue;

  String getUserInput(String category) => _userInputs[category];

  Map<String, String> get userInputs {
    Map<String, String> response = {};
    _userInputs?.forEach((key, value) {
      if (value.isNotEmpty && value != Constants.EMPTY_CHARACTER) {
        response[key] = value.toUpperCase();
      }
    });
    return response;
  }


  void resetInputs(){
    _userInputs = {};
  }
}
