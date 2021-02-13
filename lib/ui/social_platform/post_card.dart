import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../ui/widgets/content_animation.dart';
import '../../ui/widgets/my_app_bar.dart';
import '../../locator.dart';
import '../size_config.dart';
import '../text_styles.dart';
import 'label.dart';
import 'profile.dart';
import 'report_alert.dart';
import 'write_comment.dart';
import 'edit_post.dart';
import '../colors.dart';
import '../../services/firestore_service.dart';
import '../../models/post_card_model.dart';
import '../../utility/transition.dart';
import '../../utility/profile_picture.dart';

enum Marker { post, comments }
enum PaddingMarker { image, icon }
Marker selectedmarker1 = Marker.post;
PaddingMarker paddingMarker = PaddingMarker.image;

class PostCard extends StatelessWidget {
  PostCard({
    Key key,
    this.post,
  }) : super(key: key);

  final PostCardModel post;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return ContentAnimation(
      child: Container(
        margin: EdgeInsets.only(
          top: SizeConfig.v * 1.8,
          left: SizeConfig.v * 1.8,
          right: SizeConfig.v * 1.8,
        ),
        decoration: BoxDecoration(
          color: pureWhite,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: OriginalPost(
          postCard: this,
          model: post,
        ),
      ),
    );
  }
}

class OriginalPost extends StatelessWidget {
  const OriginalPost({
    Key key,
    this.postCard,
    this.model,
  }) : super(key: key);

  final PostCard postCard;
  final PostCardModel model;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
      margin: EdgeInsets.only(
        left: SizeConfig.h * 4,
        right: SizeConfig.h * 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: SizeConfig.v * 2,
              bottom: SizeConfig.h * 1,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ProfilePicture(
                  uid: model.uid,
                  photoUrl: model.photoUrl,
                  radius: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () => goToProfile(context),
                          child: SizedBox(
                            width: SizeConfig.h * 55,
                            child: AutoSizeText(
                              model.nickname,
                              maxLines: 1,
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                  fontSize: SizeConfig.h * 6,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        model.timeSincePost,
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: SizeConfig.h * 3,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                PostActions(
                  isMyPost: model.isMyPost,
                  postID: model.postID,
                  content: model.content,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.h * 1),
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Text(
                    model.content,
                    maxLines: 20,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontSize: SizeConfig.h * 3.6,
                        height: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          engagementWidgets(context),
        ],
      ),
    );
  }

  void goToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Profile(
          uid: model.uid,
          displayBackButton: true,
        ),
      ),
    );
  }

  /// Returns reactions and comments.
  Widget engagementWidgets(BuildContext context) {
    double height = 7;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Container(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LabelView(
                  widget: postCard,
                  reactionModel: postCard.post.love,
                  reaction: 'love',
                  labelColor: purple1,
                  textColor: purple3,
                ),
                LabelView(
                  widget: postCard,
                  reactionModel: postCard.post.support,
                  reaction: 'support',
                  labelColor: blue2,
                  textColor: blue3,
                ),
                LabelView(
                  widget: postCard,
                  reactionModel: postCard.post.hug,
                  reaction: 'hug',
                  labelColor: yellow2,
                  textColor: yellow3,
                ),
                LabelView(
                  widget: postCard,
                  reactionModel: postCard.post.laugh,
                  reaction: 'laugh',
                  labelColor: orange2,
                  textColor: orange3,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.v * 0.5),
              child: Container(
                height: 10,
                width: SizeConfig.h * 90,
                color: pureWhite,
                child: Row(
                  children: [
                    Spacer(),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 400),
                      height: height,
                      width: SizeConfig.h * 84 * model.love.width,
                      decoration: BoxDecoration(
                        color: purple3,
                        border: Border.all(color: pureWhite, width: 0.5),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(100),
                          bottomLeft: Radius.circular(100),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 400),
                      height: height,
                      width: SizeConfig.h * 84 * model.support.width,
                      decoration: BoxDecoration(
                        color: blue3,
                        border: Border.all(color: pureWhite, width: 0.5),
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 400),
                      height: height,
                      width: SizeConfig.h * 84 * model.hug.width,
                      decoration: BoxDecoration(
                        color: yellow3,
                        border: Border.all(color: pureWhite, width: 0.5),
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 400),
                      height: height,
                      width: SizeConfig.h * 84 * model.laugh.width,
                      decoration: BoxDecoration(
                        color: orange3,
                        border: Border.all(color: pureWhite, width: 0.5),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(100),
                          bottomRight: Radius.circular(100),
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: SizeConfig.v * 0.6,
              ),
              child: SizedBox(
                height: SizeConfig.v * 7.5,
                width: SizeConfig.h * 28.5,
                child: Stack(
                  children: [
                    commentButton(context),
                    newCommentIndicator(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget commentButton(BuildContext context) {
    final dbRef = FirebaseFirestore.instance;

    return Align(
      child: SizedBox(
        height: SizeConfig.v * 4.75,
        width: SizeConfig.h * 28.5,
        child: RaisedButton(
          color: purple3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          highlightColor: Color.fromARGB(0, 0, 0, 0),
          onPressed: () {
            DocumentReference postRef =
                dbRef.collection('posts').doc(model.postID);
            postRef.update({'newCommentsExist': false});
            Navigator.push(
              context,
              Transition.bottomToTop(
                next: CommentsView(
                  post: model,
                ),
              ),
            );
          },
          child: Text(
            'Comments',
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                fontSize: SizeConfig.h * 3.8,
                color: pureWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      alignment: Alignment.bottomCenter,
    );
  }

  Widget newCommentIndicator() {
    return Visibility(
      child: Align(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
          width: 14,
        ),
        alignment: Alignment(-1.1, -1),
      ),
      visible: model.newCommentsExist && model.isMyPost,
    );
  }
}

class CommentsView extends StatelessWidget {
  CommentsView({Key key, this.post}) : super(key: key);

  final PostCardModel post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGrey,
      appBar: MyAppBar(
        onBack: () => Navigator.pop(context),
        titleText: 'Comments',
        color: pureBlack,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  Transition.bottomToTop(
                    next: WriteComment(postID: post.postID),
                  ),
                );
              },
              child: Icon(
                Icons.add_comment,
                color: pureBlack,
                size: SizeConfig.h * 8,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(post.postID)
          .collection('comments')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return _buildList(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = CommentRecord.fromSnapshot(data);

    return CommentRow(
      uid: record.uid,
      image: record.photoUrl,
      name: record.nickname,
      comment: record.comment,
      likes: record.likes,
    );
  }

  Widget customHeaderwIcon(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 8),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: pureBlack, size: 20),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(top: 8, right: 8),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                Transition.bottomToTop(
                  next: WriteComment(postID: post.postID),
                ),
              );
            },
            child: Icon(
              Icons.add_circle_outline,
              color: pureBlack,
              size: SizeConfig.h * 8,
            ),
          ),
        ),
      ],
    );
  }
}

class CommentRow extends StatelessWidget {
  CommentRow(
      {Key key,
      this.uid,
      this.image,
      this.name,
      this.comment,
      this.time,
      this.iconButton,
      this.likes})
      : super(key: key);

  final String uid;
  final String image;
  final String name;
  final String comment;
  final String time;
  final int likes;
  final IconButton iconButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfilePicture(
            uid: uid,
            photoUrl: image,
            radius: 15,
          ),
          SizedBox(width: SizeConfig.h * 1),
          Container(
            width: SizeConfig.h * 80,
            child: RichText(
              text: TextSpan(
                text: '$name: ',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: SizeConfig.h * 4.1,
                    color: purple3,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                children: [
                  TextSpan(
                    text: comment,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 14,
                        color: pureBlack,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommentRecord {
  final String uid;
  final String comment;
  final int likes;
  final String nickname;
  final String photoUrl;
  final Timestamp timestamp;
  final DocumentReference reference;

  CommentRecord.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['uid'] != null),
        assert(map['comment'] != null),
        assert(map['likes'] != null),
        assert(map['nickname'] != null),
        assert(map['photoUrl'] != null || map['profilePicture'] != null),
        assert(map['timestamp'] != null),
        uid = map['uid'],
        comment = map['comment'],
        likes = map['likes'],
        nickname = map['nickname'],
        photoUrl = map['photoUrl'] ?? map['profilePicture'],
        timestamp = map['timestamp'];

  CommentRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

class ActionChoices {
  static const String edit = 'Edit post';
  static const String delete = 'Delete post';

  static const List<String> choices = [
    edit,
    delete,
  ];
}

class PostActions extends StatelessWidget {
  const PostActions({Key key, this.isMyPost, this.postID, this.content})
      : super(key: key);

  final bool isMyPost;
  final String postID;
  final String content;

  void chooseAction(String action, BuildContext context) {
    if (action == ActionChoices.edit) {
      print('edit');
      Navigator.push(
        context,
        Transition.bottomToTop(
          next: EditPost(
            postID: postID,
            initContent: content,
          ),
        ),
      );
    } else if (action == ActionChoices.delete) {
      print('delete');
      locator<FirestoreService>().deletePost(postID);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isMyPost) {
      return PopupMenuButton<String>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        itemBuilder: (BuildContext context) {
          return ActionChoices.choices.map((String choice) {
            return PopupMenuItem(
              value: choice,
              child: Text(
                choice,
                style: GoogleFonts.quicksand(),
              ),
            );
          }).toList();
        },
        onSelected: (String item) {
          chooseAction(item, context);
        },
      );
    } else {
      // Not my post
      return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => ReportAlert(postID: postID),
          );
        },
        child: Icon(
          Icons.outlined_flag,
          color: orange3,
          size: SizeConfig.h * 8,
        ),
      );
    }
  }
}
