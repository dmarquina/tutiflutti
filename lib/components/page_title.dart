import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String title;
  final double fontSize;
  final EdgeInsets padding;

  PageTitle(
      {this.title, this.fontSize = 60, this.padding = const EdgeInsets.only(top: 10, bottom: 15)});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: padding,
        child: Text(title,
            style:
                TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.black26)));
  }
}
