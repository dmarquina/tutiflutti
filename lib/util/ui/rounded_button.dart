import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  double _width;
  double _height;
  Color _color;
  Function _onPressed;
  bool _disabled;
  final Widget _child;

  RoundedButton.small(this._color, this._child, this._onPressed, this._disabled) {
    _width = 50.0;
    _height = 50.0;
    if (this._disabled) {
      _onPressed = null;
      _color = Colors.grey;
    }
  }

  RoundedButton.big(this._color, this._child, this._onPressed) {
    _width = 100.0;
    _height = 100.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _color,
          boxShadow: [new BoxShadow(color: const Color(0x11000000), blurRadius: 10.0)]),
      child: RawMaterialButton(
        onPressed: _onPressed,
        shape: CircleBorder(),
        elevation: 1.0,
        child: _child,
      ),
    );
  }
}
