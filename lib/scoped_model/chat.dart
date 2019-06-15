import 'package:scoped_model/scoped_model.dart';

mixin ChatModel on Model {
  int newIncomingMessages = 0;
  bool watchIncomingMessages=true;

  resetIncomingMessages() {
    newIncomingMessages = 0;
  }

  addOneIncomingMessage() {
    if (watchIncomingMessages) {
      newIncomingMessages++;
      notifyListeners();
    }
  }

  resumeWatchingIncomingMessages(){
    watchIncomingMessages=true;
  }
  stopWatchIncomingMessages(){
    watchIncomingMessages=false;
  }
}
