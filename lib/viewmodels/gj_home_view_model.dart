import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';

import '../locator.dart';
import '../models/gj_home_model.dart';
import '../services/guided_journal_service.dart';
import '../utility/transition.dart';

class GJHomeViewModel extends FutureViewModel<GJHomeModel> {
  Future<GJHomeModel> futureToRun() =>
      locator<GuidedJournalService>().constructGJHomeModel();

  bool submitted = true;

  /// `next` should be the question.
  void pushQuestion(context, next) {
    Navigator.push(
      context,
      Transition.bottomToTop(next: next),
    );
  }

  void setSubmitted(bool b) {
    submitted = b;
    notifyListeners();
  }
}
