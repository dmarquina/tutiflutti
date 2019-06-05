import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/model/conflict.dart';
import 'package:tutiflutti/page/rooms.dart';
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
        appBar: AppBar(title: Text('Puntaje'), automaticallyImplyLeading: false),
        body: StreamBuilder(
            stream: widget._model.getScoreBoard(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                Map<dynamic, dynamic> userInputs = Map.from(snapshot.data.value);
                List<dynamic> userInfoSorted = userInputs.values.toList();
                userInfoSorted.sort((a, b) => b['score'] - a['score']);
                return SingleChildScrollView(
                  child:
                      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    _buildUserInfoScores(userInfoSorted),
                  ]),
                );
              } else {
                return Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoActivityIndicator()
                    : CircularProgressIndicator();
              }
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => RoomsPage()));
            },
            child: Icon(Icons.play_arrow)));
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(userInfo['username'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
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

    Map<dynamic, dynamic> inputsReviewed = checkInputsReviewed(userInfo['inputsReviewed']);
    const String INPUTS_KEY_VALUE_SEPARATOR = '%%%';
    return inputs.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: inputs
                .map<dynamic, String>(
                    (key, value) => MapEntry(key, '$key$INPUTS_KEY_VALUE_SEPARATOR$value'))
                .values
                .toList()
                .map((value) {
              List<String> keyValue = value.split(INPUTS_KEY_VALUE_SEPARATOR);
              return RichText(
                text: TextSpan(style: TextStyle(color: Colors.black), children: [
                  TextSpan(
                    text: '${keyValue.elementAt(0)}: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text: keyValue.elementAt(1),
                      style: TextStyle(
                          color: inputsReviewed['${keyValue.elementAt(0)}'] != null
                              ? Colors.green
                              : Colors.red))
                ]),
              );
            }).toList())
        : Text('No ingresó nada');
  }

  Map<dynamic, dynamic> checkInputsReviewed(dynamic inputsRev) {
    Map<dynamic, dynamic> inputsReviewed = inputsRev != null ? inputsRev : {};
    return inputsReviewed;
  }
}
