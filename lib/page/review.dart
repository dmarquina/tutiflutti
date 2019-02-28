import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/page/conflicts.dart';
import 'package:tutiflutti/scoped_model/main.dart';

class ReviewPage extends StatelessWidget {
  String userIdToReview = '';
  String usernameToReview = '';

  Widget fetchAnswers(MainModel model, Map<String, String> userInputs, AsyncSnapshot snapshot) {
    if (userInputs.isNotEmpty) {
      int _itemCount = userInputs.length;
      List categories = userInputs.keys.toList();
      List inputs = userInputs.values.toList();
      return Flexible(
        child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: Key('${model.username}${categories[index]}${inputs[index]}'),
                direction: DismissDirection.horizontal,
                onDismissed: (DismissDirection direction) {
                  if (direction == DismissDirection.startToEnd) {
                    model.setGoodAnswers(categories[index], inputs[index], userIdToReview);
                  } else if (direction == DismissDirection.endToStart) {
                    model.insertNewConflicts(categories[index], inputs[index], userIdToReview);
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
          SizedBox(
            height: 50.0,
          ),
          Icon(
            Icons.mood_bad,
            size: 80.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(style: TextStyle(color: Colors.black), children: [
              TextSpan(
                text: 'Al parecer ',
              ),
              TextSpan(
                text: '${getUsernameToReview(snapshot)}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' no ingresó ninguna palabra',
              )
            ]),
          ),
          SizedBox(
            height: 20.0,
          ),
          FlatButton(
            onPressed: () {
              print('Me voysh');
            },
            color: Colors.teal,
            child: Text(
              'Continuar',
              style: TextStyle(color: Colors.white),
            ),
          )
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
          title: Text('Revisión'),
        ),
        body: Container(
          child: Center(
            child: StreamBuilder(
                stream: model.getUserInfo(model.userToReviewId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  Map<String, String> userInputs = model.getUserInputsToMap(snapshot);
                  return userInputs == null
                      ? CircularProgressIndicator()
                      : Column(
                          children: <Widget>[
                            buildCheckUserInputs(model, userInputs, snapshot),
                            fetchAnswers(model, userInputs, snapshot),
                          ],
                        );
                }),
          ),
        ),
      );
    });
  }

  Widget buildCheckUserInputs(
      MainModel model, Map<String, String> userInputs, AsyncSnapshot snapshot) {
    return userInputs.isEmpty
        ? Container()
        : Container(
            child: Column(
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
            ],
          ));
  }

  String getUsernameToReview(AsyncSnapshot snapshot) {
    userIdToReview = snapshot.data.key.toString();
    usernameToReview = snapshot.data.value['username'].toString();
    return usernameToReview;
  }
}
