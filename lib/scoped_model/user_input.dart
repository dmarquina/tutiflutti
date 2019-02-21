import 'package:firebase_database/firebase_database.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/model/user_input.dart';
import 'package:tutiflutti/util/firebase_child_reference.dart';

mixin UserInputModel on Model {
  Map<String, String> userInputs = {};

  addUserInput(String category, String inputValue) => userInputs[category] = inputValue;

  String getUserInput(String category) => userInputs[category];
}
