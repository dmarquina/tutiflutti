//class UserGameWordInput {
//  Map<String, Map<String, List<CategoryUserInput>>> getUserGameWordInput() {
//    Map<String, Map<String, List<CategoryUserInput>>> userGameWordInput;
//    userGameWordInput['Maluma'] = {
//      'P': [new CategoryUserInput('Nombre', 'Pepe') , new CategoryUserInput('Apellido', 'Perez') ],
//      'Z': [new CategoryUserInput('Nombre', 'Zendaya') , new CategoryUserInput('Apellido', 'Zeron') ],
//      'Q': [new CategoryUserInput('Nombre', 'Quina') , new CategoryUserInput('Apellido', 'Quintanilla')]
//    };
//
//    return userGameWordInput;
//  }
//}

class CategoryUserInput {
  String cat;
  String userInput;

  CategoryUserInput(this.cat,this.userInput);
}


//class Game {
//  String gameId;
//  Map<String, dynamic> userGameWordInput;
//
//  void asdfads() {
//    UserGameWordInput u = new UserGameWordInput();
//    Game g = new Game();
//    g.gameId = '1';
//    g.userGameWordInput = u.getUserGameWordInput();
//
//  }

//}