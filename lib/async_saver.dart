import 'dart:math' as math;
import 'package:bgug/palette.dart';
import 'package:flutter/material.dart';

import 'screens/gui_commons.dart';

class _AsyncSaverWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AsyncSaverState();
  }
}

class _AsyncSaverState extends State<_AsyncSaverWidget> {
  final List<AsyncSaver> savers = [];

  _AsyncSaverState() {
    AsyncSaver._startCallback = (saver) => setState(() => savers.add(saver));
    AsyncSaver._stopCallback = (saver) async {
      setState(() => saver._state = 1);
      await Future.delayed(Duration(seconds: 2));
      setState(() => savers.remove(saver));
    };
  }

  @override
  Widget build(BuildContext context) {
    return pad(
        Row(
          children: savers.map((s) => pad(s.toWidget(), 4.0)).toList().cast(),
        ),
        8.0);
  }
}

class AsyncSaver {
  static void Function(AsyncSaver) _startCallback;
  static void Function(AsyncSaver) _stopCallback;

  static _AsyncSaverWidget widget = _AsyncSaverWidget();

  int _state = 0;

  static AsyncSaver start() {
    AsyncSaver saver = AsyncSaver();
    _startCallback(saver);
    return saver;
  }

  void stop() {
    _stopCallback(this);
  }

  Widget toWidget() {
    if (_state == 0) {
      return _Circle();
    } else {
      return _AnimatedCheck();
    }
  }
}

class _Circle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.0,
      height: 24.0,
      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Palette.grey.color)),
    );
  }
}

class _AnimatedCheck extends StatefulWidget {
  @override
  _AnimatedCheckState createState() {
    return new _AnimatedCheckState();
  }
}

class _AnimatedCheckState extends State<_AnimatedCheck> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _curve;
  double _value = 0.0;

  _AnimatedCheckState() {
    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOut)
      ..addListener(() => setState(() {
            _value = _curve.value;
          }));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.0,
      height: 24.0,
      child: Stack(
        children: [
          Positioned(
              child: Transform.rotate(child: Container(width: 20 * _value, height: 6, color: Palette.green.color), angle: 7 * math.pi / 6),
              top: 12.0,
              left: -8.0),
          Positioned(
              child: Transform.rotate(child: Container(width: 30 * _value, height: 6, color: Palette.green.color), angle: 10 * math.pi / 6),
              top: 12.0,
              left: 2.0),
        ],
      ),
    );
  }
}