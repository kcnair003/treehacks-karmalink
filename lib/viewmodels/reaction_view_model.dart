import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:stacked/stacked.dart';

import '../locator.dart';
import '../services/firestore_service.dart';
import '../models/reaction_model.dart';
import '../ui/colors.dart';

class ReactionViewModel extends FutureViewModel<void> {
  ReactionViewModel({this.reactionModel});

  final ReactionModel reactionModel;

  bool _selected;
  bool get selected => _selected;
  // AnimationController _animationController;
  // AnimationController get animationController => _animationController;
  // Animation _animationFont;
  // Animation get animationFont => _animationFont;
  // Animation _animationEmoji;
  // Animation get animationEmoji => _animationEmoji;
  String _emoji;
  String get emoji => _emoji;

  Future<void> futureToRun() async {
    _selected = await locator<FirestoreService>().getReactionSelected(
      reactionModel.postID,
      reactionModel.name,
    );

    _emoji = chooseEmoji();
  }

  void updateReaction() {
    _selected = !_selected;
    notifyListeners();
  }

  String chooseEmoji() {
    if (reactionModel.name == 'love') {
      return parseEmoji(':heart:');
    } else if (reactionModel.name == 'support') {
      return parseEmoji(':right-facing_fist:');
    } else if (reactionModel.name == 'hug') {
      return parseEmoji(':hugging_face:');
    } else if (reactionModel.name == 'laugh') {
      return parseEmoji(':laughing:');
    } else
      return '';
  }

  String parseEmoji(String emojiName) {
    var parser = EmojiParser();
    var emoji = parser.emojify(emojiName);
    return emoji;
  }
}
