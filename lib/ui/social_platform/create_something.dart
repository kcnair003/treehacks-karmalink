import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:profanity_filter/profanity_filter.dart';

import '../colors.dart';
import '../size_config.dart';
import 'profanity.dart';

class CreateSomethingBody extends StatefulWidget {
  /// Pass in this class as body of Scaffold whenever it's a page for creating something such as a post or comment.
  CreateSomethingBody({
    Key key,
    this.onSubmit,
    this.textEditingController,
  }) : super(key: key);

  /// This function is what should happen when the user submits their post/comment/whatever.
  ///
  /// Takes TextEditingController as param so that the function can save content to the database.
  final Function(TextEditingController) onSubmit;

  /// Change this property if you need something other than a default TextEditingController.
  final TextEditingController textEditingController;

  @override
  _CreateSomethingBodyState createState() => _CreateSomethingBodyState();
}

class _CreateSomethingBodyState extends State<CreateSomethingBody> {
  final PanelController _pc = PanelController();
  TextEditingController controller;
  bool profanityPopUpOpen = false;

  @override
  void initState() {
    super.initState();
    controller = widget.textEditingController ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  style: TextStyle(
                    color: purple3,
                  ),
                  controller: controller,
                  minLines: 1,
                  maxLines: 5,
                  textInputAction: TextInputAction.next,
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
                    hintText: 'What would you like to say?',
                    hintStyle: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: SizeConfig.h * 4,
                        color: purple3,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      bool containsProfanity = checkProfanity();
                      if (containsProfanity) {
                        setState(() {
                          profanityPopUpOpen = true;
                        });
                        _pc.animatePanelToPosition(
                          1,
                          duration: Duration(milliseconds: 430),
                          curve: Curves.ease,
                        );
                      } else if (controller.text.length > 800) {
                        Fluttertoast.showToast(msg: 'Must write less');
                      } else {
                        widget.onSubmit(controller);
                      }
                    },
                    child: Icon(
                      Icons.send,
                      color: purple3,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          chooseWhetherToBlur(),
          SlidingUpPanel(
            isDraggable: false,
            maxHeight: SizeConfig.h * 150,
            minHeight: 0,
            controller: _pc,
            margin: EdgeInsets.only(
              left: SizeConfig.h * 2,
              right: SizeConfig.h * 2,
              bottom: SizeConfig.h * 7,
            ),
            parallaxEnabled: true,
            parallaxOffset: 0.5,
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
            panel: Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: SizeConfig.v * 5),
                    child: SvgPicture.asset(
                      'assets/nature.svg',
                      width: SizeConfig.h * 45,
                      height: SizeConfig.h * 45,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: SizeConfig.h * 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Uh-oh!',
                          style: TextStyle(
                            color: purple3,
                            fontSize: SizeConfig.h * 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.v * 3,
                      left: SizeConfig.h * 10,
                      right: SizeConfig.h * 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            'We detected that you might have said something harmful to yourself or someone else.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: SizeConfig.h * 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.h * 16,
                      right: SizeConfig.h * 5,
                      left: SizeConfig.h * 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: SizeConfig.h * 78,
                          height: SizeConfig.v * 7,
                          child: RaisedButton(
                            onPressed: () {
                              _pc.animatePanelToPosition(
                                0,
                                duration: Duration(milliseconds: 350),
                                curve: Curves.ease,
                              );
                              setState(() {
                                profanityPopUpOpen = false;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              side: BorderSide(color: pureWhite),
                            ),
                            elevation: 0,
                            color: Colors.orange[300],
                            child: Text(
                              'I\'ll fix it!',
                              style: TextStyle(
                                color: pureWhite,
                                fontSize: SizeConfig.h * 6.2,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget chooseWhetherToBlur() {
    return profanityPopUpOpen ? blurContainer() : SizedBox.shrink();
  }

  Widget blurContainer() {
    return Opacity(
      opacity: 1,
      child: Container(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            decoration: BoxDecoration(color: pureBlack.withOpacity(0.3)),
          ),
        ),
      ),
    );
  }

  bool checkProfanity() {
    String checkingText = controller.text;
    ProfanityFilter filter =
        ProfanityFilter.filterAdditionally(profanityList());
    bool check = filter.checkStringForProfanity(checkingText);
    return check;
  }
}
