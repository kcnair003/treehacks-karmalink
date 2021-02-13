import 'package:cloud_firestore/cloud_firestore.dart';

class Metrics {
  static final _metricsCollection =
      FirebaseFirestore.instance.collection('metrics');

  /// Total characters written.
  static void journalCharacters(int charsToAdd) {
    _metricsCollection.doc('journalCharacters').update({
      'total': FieldValue.increment(charsToAdd),
    });
  }

  /// How many times a given journal `question` is answered.
  static void journalQuestionsAnswered(String question, int charsToAdd) {
    _metricsCollection
        .doc('questionsAnswered')
        .collection('questions')
        .doc(question)
        .set(
      {
        'timesAnswered': FieldValue.increment(1),
        'charactersWritten': FieldValue.increment(charsToAdd),
      },
      SetOptions(merge: true),
    );
  }

  static void journalQuestionsIgnored(String question) {
    _metricsCollection
        .doc('questionsAnswered')
        .collection('questions')
        .doc(question)
        .set(
      {
        'timesIgnored': FieldValue.increment(1),
      },
      SetOptions(merge: true),
    );
  }

  /// Increment the number of times users have submitted a journal.
  static void journalsSubmitted() {
    _metricsCollection.doc('journalsSubmitted').update({
      'total': FieldValue.increment(1),
    });
  }

  /// How many times users have sent a message to chatbot.
  static void chatbotMessages() {
    _metricsCollection.doc('chatbotMessages').update({
      'total': FieldValue.increment(1),
    });
  }

  /// How many total characters have been sent in messages to chatbot.
  static void chatbotCharacters(int charsToAdd) {
    _metricsCollection.doc('chatbotCharacters').update({
      'total': FieldValue.increment(charsToAdd),
    });
  }
}
