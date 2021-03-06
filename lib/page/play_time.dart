import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/scoped_model/main.dart';
import 'package:tutiflutti/util/constants.dart';
import 'package:tutiflutti/util/ui/rounded_button.dart';

class PlayTimePage extends StatefulWidget {
  final MainModel model;

  PlayTimePage(this.model);

  @override
  PlayTimePageState createState() {
    return new PlayTimePageState();
  }
}

class PlayTimePageState extends State<PlayTimePage> {
  final _inputController = TextEditingController();
  String actualCategory = '';
  StreamSubscription _subscriptionGameStatus;
  BuildContext _context;

  @override
  void initState() {
    widget.model.getGameLetterFirebase();
    actualCategory = widget.model.getActualCategory();
    widget.model
        .watchIfGameStatusStop(widget.model.userId, stopEveryone)
        .then((StreamSubscription s) => _subscriptionGameStatus = s);
    super.initState();
  }

  @override
  void dispose() {
    _subscriptionGameStatus.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
          appBar: Theme.of(context).platform == TargetPlatform.iOS
              ? CupertinoNavigationBar(
                  middle: Text(Constants.TITLE, style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.teal,
                  automaticallyImplyLeading: false)
              : AppBar(title: Text(Constants.TITLE), automaticallyImplyLeading: false),
          body: SingleChildScrollView(
              child: Container(
                  child: Center(
                      child: Column(children: <Widget>[
            SizedBox(height: 50.0),
            Text('$actualCategory', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600)),
            SizedBox(height: 5.0),
            Text('que inicie con', style: TextStyle(fontSize: 14.0)),
            SizedBox(height: 5.0),
            Text(model.gameLetter, style: TextStyle(fontSize: 56.0)),
            SizedBox(height: 5.0),
            _buildInputForm(),
            _buildActionButton()
          ])))));
    });
  }

  Widget _buildInputForm() {
    final String inputValueText = widget.model.getUserInput(actualCategory);
    _inputController.text = inputValueText != null ? inputValueText : Constants.EMPTY_CHARACTER;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        controller: _inputController,
        textInputAction: TextInputAction.go,
        onFieldSubmitted: (term) {
          widget.model.addUserInput(_inputController.text, widget.model.getActualCategory());
          actualCategory = widget.model.getNextCategory();
        },
        textAlign: TextAlign.center,
        maxLength: 21,
        decoration: InputDecoration(
          hintText: actualCategory,
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
    return () {
      widget.model.addUserInput(widget.model.getActualCategory(), _inputController.text);
      actualCategory = widget.model.getPreviousCategory();
    };
  }

  Function _goNextCategory() {
    return () {
      widget.model.addUserInput(widget.model.getActualCategory(), _inputController.text);
      actualCategory = widget.model.getNextCategory();
    };
  }

  _stopGame() {
    widget.model.updateGameStatus(Constants.GAME_STATUS_STOP);
  }

  Widget _previousIcon() => Icon(Icons.navigate_before, color: Colors.white);

  Widget _stopText() => Text('STOP', style: TextStyle(color: Colors.white));

  Widget _nextIcon() => Icon(Icons.navigate_next, color: Colors.white);

  Widget _buildActionButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
        RoundedButton.small(
            Colors.teal, _previousIcon(), _goPreviousCategory(), widget.model.disabledPrev),
        RoundedButton.big(Colors.red, _stopText(), _stopGame),
        RoundedButton.small(Colors.teal, _nextIcon(), _goNextCategory(), widget.model.disabledNext),
      ]),
    );
  }

  stopEveryone() {
    widget.model.addUserInput(actualCategory, _inputController.text);
    widget.model.saveUserInputs(widget.model.userId, widget.model.userInputs);
    Navigator.pushReplacementNamed(_context, Constants.WAIT_INPUT_PATH);
  }
}
