import 'package:flutter/material.dart';

class Transition extends PageRouteBuilder {
  final Widget next;
  final int duration;

  Transition.topToBottom({
    @required this.next,
    this.duration = 300,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => next,
          transitionDuration: Duration(milliseconds: duration),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, -1.0),
              end: const Offset(0.0, 0.0),
            )
                .chain(CurveTween(curve: Curves.easeInOutCubic))
                .animate(animation),
            child: next,
          ),
        );

  Transition.bottomToTop({
    @required this.next,
    this.duration = 300,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => next,
          transitionDuration: Duration(milliseconds: duration),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: const Offset(0.0, 0.0),
            )
                .chain(CurveTween(curve: Curves.easeInOutCubic))
                .animate(animation),
            child: next,
          ),
        );

  Transition.leftToRight({
    @required this.next,
    this.duration = 300,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => next,
          transitionDuration: Duration(milliseconds: duration),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: const Offset(0.0, 0.0),
            )
                .chain(CurveTween(curve: Curves.easeInOutCubic))
                .animate(animation),
            child: next,
          ),
        );

  Transition.rightToLeft({
    @required this.next,
    this.duration = 300,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => next,
          transitionDuration: Duration(milliseconds: duration),
          reverseTransitionDuration: Duration(milliseconds: duration),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              Stack(
            children: <Widget>[
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: const Offset(0.0, 0.0),
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubic,
                )),
                child: next,
              ),
            ],
          ),
        );

  Transition.none({
    @required this.next,
    this.duration,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => next,
          transitionDuration: Duration(),
          reverseTransitionDuration: Duration(),
          transitionsBuilder: (_, _a, _b, _c) => next,
        );
}
