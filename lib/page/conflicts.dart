import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/scoped_model/main.dart';
import 'package:tutiflutti/util/constants.dart';

class ConflictsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(title: Text('Conflictos')),
        body: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 30.0),
                Text(model.gameLetter, style: TextStyle(fontSize: 56.0)),
                SizedBox(
                  height: 30.0,
                ),
                Text('¿Estas respuestas son correctas?'),
                SizedBox(height: 30.0),
                Divider(height: 2.0),
                fetchAnswers(model)
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget fetchAnswers(MainModel model) {
    return StreamBuilder(
        stream: model.getConflicts(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> conflicts = model.getConflictsInputs(snapshot);
            int _itemCount = conflicts.length;
            List conflictsList = conflicts.keys.toList();
            return Flexible(
                child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      String key =
                          '${conflicts[conflictsList[index]]['category']}${conflicts[conflictsList[index]]['answer']}${conflicts[conflictsList[index]]['owner']}';
                      return Dismissible(
                        key: Key(key),
                        direction: DismissDirection.horizontal,
                        onDismissed: (DismissDirection direction) {
                          if (direction == DismissDirection.startToEnd) {
                            model.addOneSupportConflict(key);
                          }
                          _itemCount--;
                          if (_itemCount == 0) {
                            model.subtractOneConflictReviewersLeft();
                            Navigator.pushReplacementNamed(context, Constants.WAIT_SCORE_PATH);
                          }
                        },
                        background: Container(
                            color: Colors.green,
                            child: Icon(Icons.check_circle, color: Colors.white, size: 42.0)),
                        secondaryBackground: Container(
                          color: Colors.red,
                          child: Icon(Icons.cancel, color: Colors.white, size: 42.0),
                        ),
                        child: Column(children: <Widget>[
                          ListTile(
                              title: Text(conflicts[conflictsList[index]]['category']),
                              subtitle: Text(conflicts[conflictsList[index]]['answer'])),
                          Divider(height: 2.0)
                        ]),
                      );
                    },
                    itemCount: _itemCount));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
