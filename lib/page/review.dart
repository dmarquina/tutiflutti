import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/scoped_model/main.dart';

class ReviewPage extends StatelessWidget {
  Widget fetchAnswers(MainModel model) {
    Map<String, String> userCategoryInputsNotEmpty = model.getUserCategoryInputsNotEmpty();
    List categoriesInput = userCategoryInputsNotEmpty.keys.toList();
    List valuesInput = userCategoryInputsNotEmpty.values.toList();
    return Flexible(
      child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key('${model.userName}${categoriesInput[index]}${valuesInput[index]}'),
              direction: DismissDirection.horizontal,
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.startToEnd) {
                } else if (direction == DismissDirection.endToStart) {}
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
                ListTile(title: Text(categoriesInput[index]), subtitle: Text(valuesInput[index])),
                Divider(height: 2.0,)
              ]),
            );
          },
          itemCount: userCategoryInputsNotEmpty.length),
    );
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
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  model.gameWord,
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
                      text: '${model.userName}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ]),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Divider(height: 2.0,),
                fetchAnswers(model),
              ],
            ),
          ),
        ),
      );
    });
  }
}
