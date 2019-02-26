import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/model/conflict.dart';
import 'package:tutiflutti/page/conflicts.dart';
import 'package:tutiflutti/scoped_model/main.dart';

class ReviewPage extends StatelessWidget {
  String usernameToReview = '';

  Widget fetchAnswers(MainModel model, Map<String, String> userInputs) {
    int _itemCount = userInputs.length;
    List categories = userInputs.keys.toList();
    List inputs = userInputs.values.toList();
    if (userInputs.isNotEmpty) {
      return Flexible(
        child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: Key('${model.username}${categories[index]}${inputs[index]}'),
                direction: DismissDirection.horizontal,
                onDismissed: (DismissDirection direction) {
                  if (direction == DismissDirection.startToEnd) {
//                  model.totalScore += 10;
                  } else if (direction == DismissDirection.endToStart) {
                    model.conflicts
                        .add(new Conflict(model.username, categories[index], inputs[index]));
                  }
                  _itemCount--;
                  if (_itemCount == 0) {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => ConflictsPage()));
                  }
                },
                background: Container(
                  color: Colors.green,
                  child: Icon(Icons.check_circle, color: Colors.white, size: 42.0),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  child: Icon(Icons.cancel, color: Colors.white, size: 42.0),
                ),
                child: Column(children: <Widget>[
                  ListTile(title: Text(categories[index]), subtitle: Text(inputs[index])),
                  Divider(
                    height: 2.0,
                  )
                ]),
              );
            },
            itemCount: _itemCount),
      );
    } else {
      return Center(
        child: Column(children: <Widget>[
          Text('$usernameToReview no ingreso ninguna palabra'),
          Icon(Icons.mood_bad),
          FlatButton(onPressed: (){print('Me voysh');},child: Text('CONTINUAR'),)

        ]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          title: Text('REVISIÓN'),
        ),
        body: Container(
          child: Center(
            child: StreamBuilder(
                stream: model.getUserInfo(model.userToReviewId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Column(
                    children: <Widget>[
                      SizedBox(
                        height: 50.0,
                      ),
                      Text(
                        model.gameLetter,
                        style: TextStyle(fontSize: 56.0),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(style: TextStyle(color: Colors.black), children: [
                          TextSpan(text: 'Corrobora las respuestas de '),
                          TextSpan(
                            text: '${getUsernameToReview(snapshot)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ]),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Divider(
                        height: 2.0,
                      ),
                      fetchAnswers(model, getUserInputsToMap(snapshot)),
                    ],
                  );
                }),
          ),
        ),
      );
    });
  }

  String getUsernameToReview(AsyncSnapshot snapshot) {
    usernameToReview = snapshot.data.value['username'].toString();
    return usernameToReview;
  }

  Map<String, String> getUserInputsToMap(AsyncSnapshot snapshot) {
    Map<String, String> response = {};
    if (snapshot.data.value['inputs'] != null) {
      response = Map.from(snapshot.data.value['inputs']);
    }
    return response;
  }
}
