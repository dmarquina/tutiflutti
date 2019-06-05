import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/page/wait_reviews.dart';
import 'package:tutiflutti/scoped_model/main.dart';
import 'package:tutiflutti/util/constants.dart';

class ReviewPage extends StatelessWidget {
  String userIdToReview = '';
  String usernameToReview = '';

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
          appBar: Theme.of(context).platform == TargetPlatform.iOS
              ? CupertinoNavigationBar(
                  middle: Text('Revisión', style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.teal,
                  automaticallyImplyLeading: false)
              : AppBar(title: Text('Revisión'), automaticallyImplyLeading: false),
          body: Container(
              child: Center(
                  child: StreamBuilder(
                      stream: model.getUserInfo(model.userToReviewId),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        Map<String, String> userInputs = model.getUserInputs(snapshot);
                        return _buildReview(context, model, userInputs, snapshot);
                      }))));
    });
  }

  Widget _buildReview(BuildContext context, MainModel model, Map<String, String> userInputs,
      AsyncSnapshot snapshot) {
    return Column(children: <Widget>[
      _buildCheckUserInputsMessage(model, userInputs, snapshot),
      userInputs.isNotEmpty
          ? _buildListUserInputs(model, userInputs)
          : _noInputsToCheckMessage(context, model, getUserToReview(snapshot))
    ]);
  }

  Widget _buildCheckUserInputsMessage(
      MainModel model, Map<String, String> userInputs, AsyncSnapshot snapshot) {
    return userInputs.isEmpty
        ? Container()
        : Container(
            child: Column(children: <Widget>[
            SizedBox(height: 20.0),
            Text(model.gameLetter, style: TextStyle(fontSize: 56.0)),
            SizedBox(height: 20.0),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(style: TextStyle(color: Colors.black), children: [
                  TextSpan(text: 'Corrobora las respuestas de '),
                  TextSpan(
                    text: '${getUserToReview(snapshot)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ])),
            SizedBox(height: 20.0),
            Divider(),
            _buildLegend(),
            SizedBox(height: 10.0),
            Divider(height: 2.0)
          ]));
  }

  Widget _buildLegend() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(children: <Widget>[
          Center(
              child: Text('Desliza para revisar'.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.teal))),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            Row(children: <Widget>[
              Icon(Icons.arrow_back, color: Colors.red),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Text('Incorrecto', style: TextStyle(color: Colors.red)))
            ]),
            Row(children: <Widget>[
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Text('Correcto', style: TextStyle(color: Colors.green))),
              Icon(Icons.arrow_forward, color: Colors.green)
            ])
          ])
        ]));
  }

  Widget _buildListUserInputs(MainModel model, Map<String, String> userInputs) {
    int _itemCount = userInputs.length;
    List categories = userInputs.keys.toList();
    List inputs = userInputs.values.toList();
    return Flexible(
        child: ListView.builder(
            itemCount: _itemCount,
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
                      model.subtractOneReviewersLeft();
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => WaitReviewsPage(model)));
                    }
                  },
                  background: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10.0),
                      color: Colors.green,
                      child: Icon(Icons.check, color: Colors.white, size: 30.0)),
                  secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 10.0),
                      color: Colors.red,
                      child: Icon(Icons.clear, color: Colors.white, size: 30.0)),
                  child: Column(children: <Widget>[
                    ListTile(title: Text(categories[index]), subtitle: Text(inputs[index])),
                    Divider(height: 2.0)
                  ]));
            }));
  }

  Widget _noInputsToCheckMessage(BuildContext context, MainModel model, String username) {
    return Center(
        child: Column(children: <Widget>[
      SizedBox(height: 50.0),
      Icon(Icons.mood_bad, size: 80.0),
      SizedBox(height: 20.0),
      RichText(
          textAlign: TextAlign.center,
          text: TextSpan(style: TextStyle(color: Colors.black), children: [
            TextSpan(text: 'Al parecer '),
            TextSpan(text: '$username', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' no ingresó ninguna palabra')
          ])),
      SizedBox(height: 20.0),
      FlatButton(
          color: Colors.teal,
          child: Text('Continuar', style: TextStyle(color: Colors.white)),
          onPressed: () {
            model.subtractOneReviewersLeft();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => WaitReviewsPage(model)));
          })
    ]));
  }

  String getUserToReview(AsyncSnapshot snapshot) {
    userIdToReview = snapshot.data.key.toString();
    usernameToReview = snapshot.data.value['username'].toString();
    return usernameToReview;
  }
}
