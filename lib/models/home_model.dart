class HomeModel {
  HomeModel(this.previousQuestion, this.firstName);

  final PreviousQuestion previousQuestion;
  final String firstName;
}

class PreviousQuestion {
  PreviousQuestion(this.question, this.questionCacheNum);

  final String question;
  final int questionCacheNum;
}