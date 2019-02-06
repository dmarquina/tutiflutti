import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/model/category.dart';
import 'package:tutiflutti/scoped_model/main.dart';

class StageCategory extends StatefulWidget {
  final String selectedWord;
  final MainModel model;

  StageCategory(this.selectedWord, this.model);

  @override
  StageCategoryState createState() {
    return new StageCategoryState();
  }
}

class StageCategoryState extends State<StageCategory> {
  final _inputController = TextEditingController();

  @override
  void initState() {
    widget.model.fetchCategories();
    super.initState();
  }

  Widget _buildInputForm() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        controller: _inputController,
        textAlign: TextAlign.center,
        maxLength: 21,
        decoration: InputDecoration(
          hintText: widget.model.getActualCategory().actualCategory,
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

  Widget _buildActionButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        RaisedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.navigate_before),
              Text('Atras'),
            ],
          ),
          color: Colors.blue,
          textColor: Colors.white,
          onPressed: widget.model.existsPrevCategory
              ? () {
                  widget.model.addInput(
                      _inputController.text, widget.model.getActualCategory().actualCategory);
                  _inputController.text = '';
                  widget.model.setPreviousCategory();
                }
              : null,
        ),
        RaisedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(Icons.navigate_next),
              Text('STOP'),
              Icon(Icons.navigate_before),
            ],
          ),
          color: Colors.redAccent,
          textColor: Colors.white,
          onPressed: () {
            widget.model
                .addInput(_inputController.text, widget.model.getActualCategory().actualCategory);
            _inputController.text = '';
            print(widget.model.userInputs);
          },
        ),
        RaisedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text('Continuar'),
              Icon(Icons.navigate_next),
            ],
          ),
          color: Colors.green,
          textColor: Colors.white,
          onPressed: widget.model.existsNextCategory
              ? () {
                  widget.model.addInput(
                      _inputController.text, widget.model.getActualCategory().actualCategory);
                  _inputController.text = '';
                  widget.model.setNextCategory();
                }
              : null,
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Container(
          child: Center(
              child: Column(children: <Widget>[
        SizedBox(
          height: 100.0,
        ),
        Text('${model.getActualCategory().actualCategory} que inicie con la letra: '),
        Text(
          'B',
          style: TextStyle(fontSize: 56.0),
        ),
        _buildInputForm(),
        _buildActionButton()
      ])));
    });
  }
}
