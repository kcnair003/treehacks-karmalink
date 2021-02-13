import 'package:flutter/material.dart';
import 'package:show_up_animation/show_up_animation.dart';

class ShowAnimation extends StatelessWidget {
  ShowAnimation({Key key, this.delay, this.duration, this.child})
      : super(key: key);

  final int delay;
  final int duration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShowUpAnimation(
      delayStart: Duration(milliseconds: delay),
      animationDuration: Duration(milliseconds: duration),
      curve: Curves.ease,
      direction: Direction.vertical,
      offset: 0.6,
      child: child,
    );
  }
}
