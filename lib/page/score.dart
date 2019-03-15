import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/model/conflict.dart';
import 'package:tutiflutti/scoped_model/main.dart';
import 'package:tutiflutti/util/constants.dart';
import 'package:tutiflutti/util/ui/podium_colors.dart';

class ScorePage extends StatefulWidget {
  MainModel _model;

  ScorePage(this._model);

  @override
  ScorePageState createState() => ScorePageState();
}

class ScorePageState extends State<ScorePage> {
  @override
  initState() {
    widget._model.getScoreBoard();
    widget._model.resetInputs();
    widget._model.resetCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Puntaje')),
      body: StreamBuilder(
          stream: widget._model.getScoreBoard(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              Map<dynamic, dynamic> userInputs = Map.from(snapshot.data.value);
              List<dynamic> userInfoSorted = userInputs.values.toList();
              userInfoSorted.sort((a, b) => b['score'] - a['score']);
              return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                _buildUserInfoScores(userInfoSorted),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: FlatButton(
                      child: Text('¡Jugar de nuevo!', style: TextStyle(color: Colors.white)),
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, Constants.ROOMS_PATH),
                      color: Colors.teal),
                )
              ]);
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Widget _buildUserInfoScores(List<dynamic> userInfoSorted) {
    return Column(
        children: userInfoSorted
            .map((userInfo) => Container(
                padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 0.0),
                child: Card(
                    color: PodiumColors.podiumColor(userInfoSorted.indexOf(userInfo)),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
//                            Text((userInfoSorted.indexOf(userInfo) + 1).toString()),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(userInfo['username'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: Colors.black)),
                                SizedBox(height: 4.0),
                                _buildInputs(userInfo)
                              ],
                            ),
                            Text(userInfo['score'].toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 36.0,
                                    color: Colors.black)),
                          ],
                        )))))
            .toList());
  }

  Widget _buildInputs(dynamic userInfo) {
    Map inputs = userInfo['inputs'] != null ? Map.from(userInfo['inputs']) : {};
    return inputs.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: inputs
                .map<dynamic, String>((key, value) => MapEntry(key, '$key: $value'))
                .values
                .toList()
                .map((value) => Text(
                      value,
                      style: TextStyle(color: Colors.black),
                    ))
                .toList())
        : Text('No ingreso nada');
  }
}
