import 'dart:math';

import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/model/conflict.dart';

mixin GameDevelopmentModel on Model {
  Random _random = new Random();
  List<int> a = new List<int>.generate(25, (int index) => index + 65);
  List<Conflict> conflicts = [];

  String getRandomAlphabetString() {
    int randomIndexWord = next(0, a.length);
    String gameWord = String.fromCharCode(a.elementAt(randomIndexWord));
    a.removeAt(randomIndexWord);
    return gameWord;
  }

  int next(int min, int max) => min + _random.nextInt(max - min);
}
