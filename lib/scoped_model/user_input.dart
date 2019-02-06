import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/model/user_input.dart';

mixin UserInputModel on Model {
  Map<String, UserInput> userInputs = {};

  void addInput(String inputValue, String category) {
    userInputs[category] = new UserInput('', '', inputValue, category);
  }
}
