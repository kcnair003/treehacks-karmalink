import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/gj_home_model.dart';
import '../ui/project_level_data.dart';

class GuidedJournalService {
  final random = Random();
  final ref = FirebaseDatabase.instance.reference();
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');

  Future<GJHomeModel> constructGJHomeModel() async {
    return GJHomeModel(
      prompts: await addPrompts(),
    );
  }

  /// Check for prompts in cache. If absent, get them.
  Future<List<String>> addPrompts() async {
    var prefs = await SharedPreferences.getInstance();
    List<String> prompts = List<String>();

    if (await cacheExists('prompts')) {
      prompts = prefs.getStringList('prompts');
    } else {
      Set<int> questionIndices = await indices(5);

      // Get the questions associated with each of the indices.
      for (int i in questionIndices) {
        DataSnapshot snapshot =
            await ref.child('questions').child('q$i').once();
        var value = snapshot.value;
        prompts.add(value['question']);
      }

      cacheQuestionsIndividually(prompts);
      await prefs.setStringList('prompts', prompts);
    }

    return prompts;
  }

  void cacheQuestionsIndividually(List<String> questions) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('question0', 'Free write');
    for (int i = 0; i < 5; i++) {
      prefs.setString('question${i + 1}', questions[i]);
    }
  }

  /// Generate `n` random, unique indices.
  Future<Set<int>> indices(int n) async {
    Set<int> indices = Set<int>();
    int totalQuestions = await getNumOfQuestions();
    while (indices.length < 5) {
      var index = random.nextInt(totalQuestions);
      indices.add(index);
    }

    return indices;
  }

  Future<int> getNumOfQuestions() async {
    var snapshot = await ref.child('numOfQuestions').once();
    return snapshot.value;
  }

  /// Check if `key` is currently cached.
  static Future<bool> cacheExists(String key) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) != null;
  }

  static void updateTimeUsed(List keywords) {
    keywords.forEach((keyword) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(ProjectLevelData.user.uid)
          .collection('personal keyword list')
          .doc(keyword)
          .update({
        'time used': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      });
    });
  }

  /// Check if the personal keyword is in the total keyword list to determine
  /// whether images exist. Documents are removed from total keyword list in
  /// back-end if the crawler yielded no images.
  static Future<bool> isInTotal(DocumentSnapshot document) async {
    String keyword = document.id;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('total_keyword_list')
        .doc(keyword)
        .get();

    bool wordExists = snapshot.exists;
    if (wordExists) {
      return true;
    } else {
      DocumentReference ref = document.reference;
      ref.delete();
      return false;
    }
  }

  /// Get the cached answer. Return empty string if null.
  Future<String> getAnswer(int questionNum) async {
    var prefs = await SharedPreferences.getInstance();
    String answer = prefs.getString('answer$questionNum') ?? '';
    return answer;
  }

  void updateJournalStreak() async {
    var userDoc = _usersCollectionReference.doc(ProjectLevelData.user.uid);
    var userSnapshot = await userDoc.get();
    var timestamp = userSnapshot.data()['lastJournalSubmitted'];
    bool continueStreak = true;
    _usersCollectionReference.doc(ProjectLevelData.user.uid).update({
      'journalStreak': continueStreak ? FieldValue.increment(1) : 0,
      'lastJournalSubmitted': FieldValue.serverTimestamp(),
    });
  }
}
