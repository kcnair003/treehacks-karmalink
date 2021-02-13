import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:temporary/models/gj_home_model.dart';
import 'package:temporary/ui/chat/conversation_view.dart';
import 'package:temporary/ui/chat/directory_view.dart';
import 'package:temporary/utility/transition.dart';

import '../../services/metrics.dart';
import '../colors.dart';
import '../project_level_data.dart';
import '../size_config.dart';
import '../../viewmodels/gj_home_view_model.dart';
import '../text_styles.dart';
import 'text_input.dart';
import '../widgets/decorated_container.dart';
import '../widgets/content_animation.dart';

class GJHome extends StatelessWidget {
  GJHome({Key key}) : super(key: key);

  // https://www.youtube.com/watch?v=SY3bX3VN-HY&feature=youtu.be
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //   future: FirebaseFirestore.instance
    //       .collection('total_keyword_list')
    //       .doc('amazing')
    //       .get(),
    //   builder: (context, AsyncSnapshot snapshot) {
    //     if (!snapshot.hasData) {
    //       return CircularProgressIndicator();
    //     }
    //     DocumentSnapshot docSnap = snapshot.data;
    //     Map<String, dynamic> data = docSnap.data();
    //     int frequency = data['frequency'];
    //     return Scaffold(
    //       body: Center(
    //         child: Text('$frequency'),
    //       ),
    //     );
    //   },
    // );
    // return ConversationView();
    return DirectoryView();
    //   SizeConfig().init(context);

    //   return AnnotatedRegion<SystemUiOverlayStyle>(
    //     value: SystemUiOverlayStyle.dark,
    //     child: SafeArea(
    //       child: Scaffold(
    //         key: scaffoldKey,
    //         backgroundColor: backgroundGrey,
    //         body: ViewModelBuilder<GJHomeViewModel>.reactive(
    //           viewModelBuilder: () => GJHomeViewModel(),
    //           builder: (context, model, child) {
    //             if (model.data == null) {
    //               return Center(child: CircularProgressIndicator());
    //             } else {
    //               var data = model.data;
    //               return Padding(
    //                 padding: const EdgeInsets.all(16),
    //                 child: ListView(
    //                   children: [
    //                     ContentAnimation(
    //                       child: Row(
    //                         children: [
    //                           Text(
    //                             'Journal',
    //                             style: TextStyle(
    //                               color: orange3,
    //                               fontSize: 30,
    //                               fontWeight: FontWeight.w800,
    //                             ),
    //                           ),
    //                           Spacer(),
    //                           Visibility(
    //                             visible: !model.submitted,
    //                             child: SubmitButton(
    //                               scaffoldKey: scaffoldKey,
    //                               gjHomeViewModel: model,
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     SizedBox(height: 8),
    //                     DisplayQuestions(gjHomeModel: data),
    //                   ],
    //                 ),
    //               );
    //             }
    //           },
    //         ),
    //       ),
    //     ),
    //   );
  }
}

class DisplayQuestions extends StatelessWidget {
  DisplayQuestions({Key key, this.gjHomeModel}) : super(key: key);

  final GJHomeModel gjHomeModel;

  @override
  Widget build(BuildContext context) {
    bool submitted = context.watch<GJHomeViewModel>().submitted;
    if (submitted) {
      return Padding(
        padding: const EdgeInsets.only(top: 32),
        child: FlatButton(
          onPressed: () {
            context.read<GJHomeViewModel>().setSubmitted(false);
            Transition.none(next: GJHome());
          },
          child: Text(
            'Get new journal questions',
            style: TextStyles.quicksand(24, Colors.grey[600]),
          ),
        ),
      );
    } else {
      return Column(children: [
        ContentAnimation(
          delay: 100,
          child: QuestionCard(
            questionNum: 0,
            question: 'Free write',
            type: 'text',
          ),
        ),
        ContentAnimation(
          delay: 200,
          child: QuestionCard(
            questionNum: 1,
            question: gjHomeModel.prompts[0],
            type: 'text',
          ),
        ),
        ContentAnimation(
          delay: 300,
          child: QuestionCard(
            questionNum: 2,
            question: gjHomeModel.prompts[1],
            type: 'text',
          ),
        ),
        ContentAnimation(
          delay: 400,
          child: QuestionCard(
            questionNum: 3,
            question: gjHomeModel.prompts[2],
            type: 'text',
          ),
        ),
        ContentAnimation(
          delay: 500,
          child: QuestionCard(
            questionNum: 4,
            question: gjHomeModel.prompts[3],
            type: 'text',
          ),
        ),
        ContentAnimation(
          delay: 600,
          child: QuestionCard(
            questionNum: 5,
            question: gjHomeModel.prompts[4],
            type: 'text',
          ),
        ),
      ]);
    }
  }
}

class QuestionCard extends StatelessWidget {
  const QuestionCard({Key key, this.questionNum, this.question, this.type})
      : super(key: key);

  final int questionNum;
  final String question;
  final String type;

  void goToQuestion(BuildContext context) {
    Provider.of<GJHomeViewModel>(context, listen: false).pushQuestion(
      context,
      TextInputPage(
        questionCacheNum: questionNum,
        question: question,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: GestureDetector(
        onTap: () => goToQuestion(context),
        child: DecoratedContainer(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${questionNum + 1}. ',
                    style: TextStyle(
                      color: pureWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: question,
                    style: TextStyle(
                      color: pureWhite,
                      fontSize: 23,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    Key key,
    @required this.scaffoldKey,
    @required this.gjHomeViewModel,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final GJHomeViewModel gjHomeViewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.h * 30,
      height: SizeConfig.v * 7,
      child: RaisedButton(
        color: purple3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => SubmitAlert(
              scaffoldKey: scaffoldKey,
              gjHomeViewModel: gjHomeViewModel,
            ),
          );
        },
        child: Text(
          'Submit',
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              fontSize: SizeConfig.h * 5.4,
              color: pureWhite,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class SubmitAlert extends StatefulWidget {
  const SubmitAlert({
    Key key,
    @required this.scaffoldKey,
    @required this.gjHomeViewModel,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final GJHomeViewModel gjHomeViewModel;

  @override
  _SubmitAlertState createState() => _SubmitAlertState();
}

class _SubmitAlertState extends State<SubmitAlert> {
  final int numOfQuestions = 6;

  void handleSubmit(context) async {
    bool valid = await validateTextInputs(context);

    if (valid) {
      for (int i = 0; i < numOfQuestions; i++) {
        saveTextInput(i);
      }

      await clearJournal();

      widget.gjHomeViewModel.setSubmitted(true);
    }
  }

  String totalTextInput = '';

  Future<bool> validateTextInputs(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    // Map<String, String> journal = Map<String, String>();
    List<String> selectedImages = prefs.getStringList('selectedImages');

    int chars = 0;
    for (int i = 0; i < numOfQuestions; i++) {
      // Return emptry string if null
      // var question = prefs.getString('question$i') ?? '';
      var answer = prefs.getString('answer$i') ?? '';
      // journal.putIfAbsent(question, () => answer);

      chars += answer.length;
    }

    const int minCharRequirement = 150;
    if (chars < minCharRequirement) {
      // Ask user to write more characters
      widget.scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 20),
        content: Text(
          'Reflecting more will let you learn about yourself and give you more '
          'insightful trends. Please write at least ${minCharRequirement - chars} '
          'more characters.',
          style: GoogleFonts.quicksand(),
        ),
        action: SnackBarAction(
          label: 'Got it',
          onPressed: widget.scaffoldKey.currentState.hideCurrentSnackBar,
        ),
      ));

      return false;
    } else {
      widget.scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Successfully submitted',
          style: TextStyles.roboto(14, pureWhite),
        ),
      ));

      return true;
    }
  }

  Future<bool> getShareData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(ProjectLevelData.user.uid)
        .get();

    if (snapshot.data()['shareData'] != null) {
      return snapshot.data()['shareData'];
    } else {
      return false;
    }
  }

  void saveTextInput(int questionNum) async {
    final ref = FirebaseFirestore.instance.collection('guided_journals');
    var prefs = await SharedPreferences.getInstance();
    // If questionCacheNum is 0, use the permanent first question
    var question = questionNum == 0
        ? 'Free write'
        : prefs.getString('question$questionNum') ?? '';
    var answer = prefs.getString('answer$questionNum') ?? '';
    var formattedDate = getFormattedDate();

    /// Save individual text input
    /// Don't save if they don't answer
    if (answer.isNotEmpty) {
      print('saving answer to firestore: $answer');
      await ref
          .doc(ProjectLevelData.user.uid)
          .collection('daily_journals')
          .add({
        'question': question,
        'datetime': formattedDate,
        'weekday': getWeekday(),
        'journal_text': answer,
        'key': prefs.getString('key'),
      });
      Metrics.journalQuestionsAnswered(question, answer.length);
    } else if (answer.isEmpty) {
      Metrics.journalQuestionsIgnored(question);
    }

    // Add to total text input
    totalTextInput = '$totalTextInput $answer';

    // Save total text input when finished
    if (questionNum == numOfQuestions) {
      await ref
          .doc(ProjectLevelData.user.uid)
          .collection('daily_journals')
          .add({
        'datetime': formattedDate,
        'weekday': getWeekday(),
        'journal_text': totalTextInput,
        'key': prefs.getString('key'),
      });
    }

    // Save to deidentified guided journals if user opted to share data
    bool shareData = await getShareData();
    if (shareData) {
      await FirebaseFirestore.instance
          .collection('deidentified_guided_journals')
          .add({
        'datetime': formattedDate,
        'question': question,
        'journal_text': answer,
      });
    }
  }

  Future<String> getString(SharedPreferences prefs, String key) async {
    return prefs.getString(key);
  }

  void saveSelectedImages() async {
    final prefs = await SharedPreferences.getInstance();

    FirebaseFirestore.instance
        .collection('guided_journals')
        .doc(ProjectLevelData.user.uid)
        .collection('daily_image_selection')
        .doc(getFormattedDate())
        .set({
      'selected_images': prefs.getStringList('selectedImages'),
      'weekday': getWeekday(),
    });
  }

  String getFormattedDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return formattedDate;
  }

  String getWeekday() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE').format(now);
    return formattedDate;
  }

  Future<void> clearJournal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('prompts');
    await prefs.remove('keywords');
    await prefs.remove('selectedImages');
    for (int i = 0; i < numOfQuestions; i++) {
      await prefs.remove('question$i');
      await prefs.remove('answer$i');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtain a different context to show SnackBar
    // https://stackoverflow.com/questions/51304568/scaffold-of-called-with-a-context-that-does-not-contain-a-scaffold
    return Builder(
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'Are you sure you want to submit all answers for this session?',
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.cancel, color: Colors.orange[300]),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Icon(Icons.check, color: Colors.orange[300]),
            onPressed: () {
              dismissAlert();
              handleSubmit(context);
            },
          ),
        ],
      ),
    );
  }

  void dismissAlert() {
    Navigator.pop(context);
  }
}
