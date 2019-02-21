import 'dart:math';

class RandomWord {
  static Random _random = new Random();
  static List<int> a = new List<int>.generate(25, (int index) => index + 65);

  static String getRandomWord() {
    int randomIndexWord = next(0, a.length);
    String gameWord = String.fromCharCode(a.elementAt(randomIndexWord));
    a.removeAt(randomIndexWord);
    return gameWord;
  }

  static int next(int min, int max) => min + _random.nextInt(max - min);
}
