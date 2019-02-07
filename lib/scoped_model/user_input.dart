import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/model/user_input.dart';

mixin UserInputModel on Model {
  String userName = '';
  Map<String, UserInput> userInputs = {};

  void addUserInput(String inputValue, String category) {
    userInputs[category] = new UserInput('', userName, inputValue, category);
  }

  UserInput getUserInput(String category){
    return userInputs[category];
  }
}
