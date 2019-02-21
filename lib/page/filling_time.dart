import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/page/review.dart';
import 'package:tutiflutti/scoped_model/main.dart';
import 'package:tutiflutti/util/constants.dart';
import 'package:tutiflutti/util/random_letter.dart';
import 'package:tutiflutti/util/ui/rounded_button.dart';

class FillingTimePage extends StatefulWidget {
  final MainModel model;

  FillingTimePage(this.model);

  @override
  FillingTimePageState createState() {
    return new FillingTimePageState();
  }
}

class FillingTimePageState extends State<FillingTimePage> {
  final _inputController = TextEditingController();
  String gameLetter = Constants.EMPTY_CHARACTER;
  StreamSubscription _subscriptionGameStatus;

  @override
  void initState() {
    widget.model.updateGameLetter();
    widget.model.gameLetter.then((letter) => gameLetter = letter);
    widget.model.fetchCategories();
    widget.model
        .watchIfGameStatusStop(stopEveryone)
        .then((StreamSubscription s) => _subscriptionGameStatus = s);
    super.initState();
  }

  @override
  void dispose() {
    _subscriptionGameStatus.cancel();
    super.dispose();
  }

  Widget _buildInputForm() {
    final String actualCategoryText = widget.model.getActualCategory().actualCategory;
    final String inputValueText = widget.model.getUserInput(actualCategoryText);
    _inputController.text = inputValueText != null ? inputValueText : Constants.EMPTY_CHARACTER;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        controller: _inputController,
        textInputAction: TextInputAction.go,
        onFieldSubmitted: (term) {
          widget.model
              .addUserInput(_inputController.text, widget.model.getActualCategory().actualCategory);
          widget.model.setNextCategory();
        },
        textAlign: TextAlign.center,
        maxLength: 21,
        decoration: InputDecoration(
          hintText: actualCategoryText,
          hintStyle: new TextStyle(color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(50.0),
            ),
          ),
        ),
      ),
    );
  }

  Function _goPreviousCategory() {
    return widget.model.existsPrevCategory
        ? () {
            widget.model.addUserInput(
                widget.model.getActualCategory().actualCategory, _inputController.text);
            widget.model.setPreviousCategory();
          }
        : null;
  }

  Function _goNextCategory() {
    return widget.model.existsNextCategory
        ? () {
            widget.model.addUserInput(
                widget.model.getActualCategory().actualCategory, _inputController.text);
            widget.model.setNextCategory();
          }
        : null;
  }

  void _stopGame() {
    widget.model.updateGameStatus(Constants.GAME_STATUS_STOP);
  }

  Widget _previousIcon() => Icon(Icons.navigate_before, color: Colors.white);

  Widget _stopText() => Text('STOP', style: TextStyle(color: Colors.white));

  Widget _nextIcon() => Icon(Icons.navigate_next, color: Colors.white);

  Widget _buildActionButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
        RoundedButton.small(Colors.teal, _previousIcon(), _goPreviousCategory),
        RoundedButton.big(Colors.red, _stopText(), _stopGame),
        RoundedButton.small(Colors.teal, _nextIcon(), _goNextCategory),
      ]),
    );
  }

  void stopEveryone() {
    widget.model
        .addUserInput(widget.model.getActualCategory().actualCategory, _inputController.text);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ReviewPage()));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
          appBar: AppBar(
            title: Text(Constants.TITLE),
          ),
          body: Container(
              child: Center(
                  child: Column(children: <Widget>[
            SizedBox(
              height: 50.0,
            ),
            Text('${model.getActualCategory().actualCategory} que inicie con la letra: '),
            Text(
              gameLetter,
              style: TextStyle(fontSize: 56.0),
            ),
            _buildInputForm(),
            _buildActionButton()
          ]))));
    });
  }
}
