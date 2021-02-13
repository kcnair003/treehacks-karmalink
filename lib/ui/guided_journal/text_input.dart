import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../size_config.dart';
import '../colors.dart';
import '../../locator.dart';
import '../../services/guided_journal_service.dart';

/// Ask for text input in the guided journal
class TextInputPage extends StatefulWidget {
  TextInputPage({
    Key key,
    this.question,
    this.questionCacheNum,
  }) : super(key: key);

  final String question;
  final int questionCacheNum;

  @override
  _TextInputPageState createState() => _TextInputPageState();
}

class _TextInputPageState extends State<TextInputPage> {
  var controller = TextEditingController();

  Future initController() async {
    var _gjService = locator<GuidedJournalService>();
    var answer = await _gjService.getAnswer(widget.questionCacheNum);
    controller = TextEditingController(text: answer);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: backgroundGrey,
      // resizeToAvoidBottomInset: false,
      body: actualBody(),
    );
  }

  Widget negativeSpaceGestureDetector() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        width: SizeConfig.h * 100,
        height: SizeConfig.v * 100,
        decoration: BoxDecoration(
          color: orange3,
        ),
      ),
    );
  }

  Widget actualBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.v * 4),
            child: Text(
              widget.question,
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  height: 1.2,
                  fontSize: SizeConfig.v * 4,
                  color: orange3,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder(
                future: initController(),
                builder: (context, snapshot) => TextFormField(
                  style: TextStyle(color: purple3),
                  controller: controller,
                  minLines: 1,
                  maxLines: 5,
                  textInputAction: TextInputAction.go,
                  textAlignVertical: TextAlignVertical(y: 0),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black12,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    hintText: 'Type here',
                    hintStyle: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: SizeConfig.h * 4,
                        color: purple3,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.v * 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                saveButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget saveButton() {
    return Padding(
      padding: EdgeInsets.only(right: SizeConfig.h * 4),
      child: SizedBox(
        width: SizeConfig.h * 30,
        height: SizeConfig.v * 7,
        child: RaisedButton(
          color: purple3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          onPressed: () async {
            cacheTextInput();
            Navigator.of(context).pop();
          },
          child: Text(
            'Save',
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                fontSize: SizeConfig.h * 5.4,
                color: pureWhite,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void cacheTextInput() async {
    final prefs = await SharedPreferences.getInstance();
    // If questionCacheNum is 0, use the permanent first question
    prefs.setString(
      'question${widget.questionCacheNum}',
      widget.questionCacheNum == 0 ? 'Free write' : widget.question,
    );
    prefs.setString('answer${widget.questionCacheNum}', controller.text);

    // Cache parameters for the current question to resume later
    prefs.setString('previous question', '${widget.question}');
    prefs.setInt('previous questionCacheNum', widget.questionCacheNum);
  }
}

class CharacterCount extends StatefulWidget {
  /// Display how many characters there are currently in real time
  /// Not working, so this class isn't referenced anywhere
  const CharacterCount({Key key, this.controller}) : super(key: key);

  final TextEditingController controller;

  @override
  _CharacterCountState createState() => _CharacterCountState();
}

class _CharacterCountState extends State<CharacterCount> {
  int length;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        length = widget.controller.text.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('$length characters');
  }
}
