import 'package:flutter/material.dart';

import '../colors.dart';

class DecoratedContainer extends Container {
  DecoratedContainer({
    Key key,
    Alignment alignment,
    EdgeInsetsGeometry padding,
    Color color,
    Decoration foregroundDecoration,
    double width,
    double height,
    BoxConstraints constraints,
    EdgeInsetsGeometry margin,
    Matrix4 transform,
    Widget child,
    Clip clipBehavior = Clip.none,
  }) : super(
          key: key,
          alignment: alignment,
          padding: padding,
          color: color,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                yellow3,
                orange2,
              ],
            ),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black54.withOpacity(.15),
                spreadRadius: 1,
                blurRadius: 8,
              ),
            ],
          ),
          foregroundDecoration: foregroundDecoration,
          width: width,
          height: height,
          constraints: constraints,
          margin: margin,
          transform: transform,
          child: child,
          clipBehavior: clipBehavior,
        );
}
