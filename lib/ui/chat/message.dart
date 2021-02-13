import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../size_config.dart';

class Message extends StatelessWidget {
  Message({Key key, this.messageModel, this.userModel}) : super(key: key);

  final MessageModel messageModel;
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: messageModel.isMine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Visibility(
            visible: !messageModel.isMine,
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(userModel.photoUrl),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            constraints:
                BoxConstraints(minHeight: 10, minWidth: 40, maxWidth: 230),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(13.0),
              ),
              color: messageModel.isMine
                  ? Color.fromRGBO(143, 219, 210, 1)
                  : Color.fromRGBO(230, 230, 230, 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 6),
                  child: Text(
                    messageModel.messageText,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        color: messageModel.isMine
                            ? Colors.white
                            : Colors.grey[700],
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
