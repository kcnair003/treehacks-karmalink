import 'package:flutter/material.dart';

typedef YesNoBuilder = Widget Function(BuildContext, YesNoController);

/// Declarative API for a popup that will prompt the user to confirm or deny
/// a decision before moving forward.
class YesNoPopUp extends StatefulWidget {
  YesNoPopUp({
    this.questionText,
    this.onConfirm,
    this.onDeny,
    this.yesText = 'Yes',
    this.noText = 'No',
    this.builder,
  });

  final String questionText;
  final Function onConfirm;
  final Function onDeny;
  final String yesText;
  final String noText;

  /// Takes [BuildContext] and [YesNoController] and must return a [Widget].
  final YesNoBuilder builder;

  @override
  _YesNoPopUpState createState() => _YesNoPopUpState();
}

class _YesNoPopUpState extends State<YesNoPopUp> {
  YesNoController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YesNoController(widget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _controller);
  }
}

class YesNoController {
  YesNoController(this.popUpWidget);

  final YesNoPopUp popUpWidget;

  Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                popUpWidget.questionText,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => popUpWidget.onConfirm(),
                    child: Text(popUpWidget.yesText),
                  ),
                  TextButton(
                    onPressed: () => popUpWidget.onDeny(),
                    child: Text(popUpWidget.noText),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
