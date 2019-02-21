import 'dart:core';
import 'dart:math';

class RandomLetter {
  static Random _random = new Random();

  static Map<String, List<int>> getRandomLetter(List<int> missingLetters) {
    int randomIndexLetter = next(0, missingLetters.length);
    String gameLetter = String.fromCharCode(missingLetters.elementAt(randomIndexLetter));
    missingLetters.removeAt(randomIndexLetter);
    return {gameLetter: missingLetters};
  }

  static int next(int min, int max) => min + _random.nextInt(max - min);
}
