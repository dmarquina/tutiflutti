import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/scoped_model/main.dart';

class ReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          title: Text('RESUMEN'),
        ),
        body: Container(
          child: Column(
              children: model.userGameWordInputs.keys
                  .map((userName) => Container(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Text(userName),
                            Container(
                                padding: EdgeInsets.all(2.0),
                                child: Column(
                                    children: model.userGameWordInputs[userName].keys
                                        .map(
                                          (gameWord) => Container(
                                                child: Column(
                                                  children: <Widget>[
                                                    Text(gameWord),
                                                    Column(
                                                        children: model
                                                            .userGameWordInputs[userName][gameWord]
                                                            .keys
                                                            .map((cat) => Container(
                                                                  child: Row(
                                                                    children: <Widget>[
                                                                      Text(cat),
                                                                      Text(' : '),
                                                                      Text(model.userGameWordInputs[
                                                                          userName][gameWord][cat])
                                                                    ],
                                                                  ),
                                                                ))
                                                            .toList())
                                                  ],
                                                ),
                                              ),
                                        )
                                        .toList()))
                          ],
                        ),
                      )))
                  .toList()),
        ),
      );
    });
  }
}
