import 'dart:async';

import 'package:flutter/material.dart';

class ContentAnimation extends StatefulWidget {
  /// Wrap around a widget to have it animate as it appears on a newly pushed page.
  ContentAnimation({Key key, this.child, this.delay = 0}) : super(key: key);

  final Widget child;
  final int delay;

  @override
  _ContentAnimationState createState() => _ContentAnimationState();
}

class _ContentAnimationState extends State<ContentAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _curvedAnimation;
  Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _scaleAnimation = Tween(
      begin: 0.9,
      end: 1.0,
    ).animate(_curvedAnimation);

    Timer(
      Duration(milliseconds: widget.delay),
      () => _controller.forward(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _curvedAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
