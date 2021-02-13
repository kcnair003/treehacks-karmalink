import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import '../../locator.dart';
import '../size_config.dart';
import '../colors.dart';
import '../../viewmodels/reaction_view_model.dart';
import '../../services/firestore_service.dart';
import '../../models/reaction_model.dart';
import 'post_card.dart';

class LabelView extends StatelessWidget {
  LabelView(
      {Key key,
      this.widget,
      this.reactionModel,
      this.reaction,
      this.labelColor,
      this.textColor})
      : super(key: key);

  final PostCard widget;
  final ReactionModel reactionModel;
  final String reaction;
  final Color labelColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.h * 2),
      child: ViewModelBuilder<ReactionViewModel>.reactive(
        viewModelBuilder: () => ReactionViewModel(
          reactionModel: reactionModel,
        ),
        builder: (context, model, child) => model.isBusy
            ? LabelPlaceholder(
                labelColor: labelColor,
              )
            : Label(
                labelColor: labelColor,
                textColor: textColor,
                text: '#$reaction',
                width: SizeConfig.h * 26,
                updateDB: (bool clicked) {
                  locator<FirestoreService>()
                      .updateReaction(widget.post.postID, reaction, clicked);
                },
                scale: 0.66,
                selected: model.selected,
              ),
      ),
    );
  }
}

class Label extends StatefulWidget {
  Label({
    Key key,
    this.textColor,
    this.text,
    this.labelColor,
    this.width,
    this.updateDB,
    this.scale,
    this.selected,
  }) : super(key: key);

  final Color textColor;
  final Color labelColor;
  final String text;
  final double width;
  final Function(bool) updateDB;

  /// Whether the reaction is already selected by the user.
  /// Determines if the AnimatedContainer should start open or closed.
  final bool selected;
  final double scale;

  @override
  _LabelState createState() => _LabelState();
}

class _LabelState extends State<Label> with TickerProviderStateMixin {
  var _animationController;
  var _animationFont;
  var _animationEmoji;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    Animation curve = CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    );
    _animationFont = Tween(begin: 1.0, end: 2.0).animate(curve);
    _animationEmoji = Tween(begin: 1.0, end: 1.2).animate(curve);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    if (Provider.of<ReactionViewModel>(context).selected) {
      _animationController.forward();
    }

    return Consumer<ReactionViewModel>(
      builder: (context, model, _) {
        return GestureDetector(
          onTap: () {
            widget.updateDB(model.selected);
            model.updateReaction();
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            width: (model.selected
                ? widget.width * widget.scale
                : SizeConfig.h * 13 * widget.scale),
            height: SizeConfig.h * 13 * widget.scale,
            decoration: BoxDecoration(
              color: (model.selected ? widget.textColor : widget.labelColor),
              boxShadow: [
                BoxShadow(
                  color:
                      model.selected ? Colors.grey.withOpacity(0.4) : pureWhite,
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(1, 6),
                )
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: (model.selected
                  ? AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform(
                          transform: Matrix4.identity()
                            ..scale(_animationFont.value),
                          alignment: FractionalOffset.center,
                          child: child,
                        );
                      },
                      child: Text(
                        widget.text,
                        style: TextStyle(
                          color:
                              (model.selected ? pureWhite : widget.textColor),
                          fontSize: SizeConfig.h * 2.8 * widget.scale,
                        ),
                      ),
                    )
                  : AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform(
                          transform: Matrix4.identity()
                            ..scale(_animationEmoji.value),
                          alignment: FractionalOffset.center,
                          child: child,
                        );
                      },
                      child: Text(
                        model.emoji,
                        style: TextStyle(fontSize: 18),
                      ),
                    )),
            ),
          ),
        );
      },
    );
  }
}

class LabelPlaceholder extends StatelessWidget {
  /// Widget to build while `model` is busy.
  const LabelPlaceholder({Key key, this.labelColor}) : super(key: key);

  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: SizeConfig.h * 8.5,
      height: SizeConfig.h * 8.5,
      decoration: BoxDecoration(
        color: labelColor,
        boxShadow: [
          BoxShadow(
            color: pureWhite,
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(1, 6),
          )
        ],
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
