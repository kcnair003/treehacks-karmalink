import 'package:flutter/material.dart';

import '../size_config.dart';

class SizedStateless extends StatelessWidget {
  SizedStateless({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return child;
  }

  double get v => SizeConfig.v;

  double get h => SizeConfig.h;
}

class SizedStateful extends StatefulWidget {
  /// ```
  /// class Foo extends SizedStateful {
  ///   Foo({Key key}) : super(key: key);
  ///   @override
  ///   FooState createState() => FooState();
  /// }
  /// class FooState extends SizedStatefulState {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Container(
  ///       height: v*2,
  ///     );
  ///   }
  /// }
  /// ```
  SizedStateful({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  SizedStatefulState createState() => SizedStatefulState();
}

class SizedStatefulState extends State<SizedStateful> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return widget.child;
  }

  double get v => SizeConfig.v;

  double get h => SizeConfig.h;
}

void bruh() {
  SizedStateful();
}
