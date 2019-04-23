class Constants {
  static const String TITLE = 'TUTI FRUTTI';
  static const String EMPTY_CHARACTER = '';

  // GAME STATUS
  static const String GAME_STATUS_WAITING = 'waiting';
  static const String GAME_STATUS_IN_PROGRESS = 'inprogress';
  static const String GAME_STATUS_STOP = 'stop';

  // PATHS
  static const String HOME_PATH = '/';
  static const String ROOMS_PATH = '/rooms';
  static const String WAITING_ROOM_PATH = '/waitingroom';
  static const String START_GAME_PATH = '/startgame';
  static const String WAIT_INPUT_PATH = '/waitinput';
  static const String REVIEW_PATH = '/review';
  static const String WAIT_REVIEWS_PATH = '/waitreviews';
  static const String CONFLICTS_PATH = '/conflicts';
  static const String WAIT_SCORE_PATH = '/waitscore';
  static const String SCORE_PATH = '/score';

  //SCORES
  static const int POINTS_FOR_GOOD_ANSWER = 100;
  static const int POINTS_FOR_REPEATED_GOOD_ANSWER = 50;
  static const int NEGATIVE_POINTS_FOR_GOOD_REPEATED_ANSWER = -50;

  //UTIL METHODS
  static List<int> calcInitialMissingLettersList() {
    int alphabeticLettersNumber = 25;
    int indexHexAlphabeticLetters = 65;
    return new List<int>.generate(
        alphabeticLettersNumber, (int index) => index + indexHexAlphabeticLetters);
  }
}
