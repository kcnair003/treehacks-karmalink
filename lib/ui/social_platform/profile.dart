import 'package:cloud_firestore/cloud_firestore.dart' hide Settings;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:temporary/ui/widgets/creation_aware_list_item.dart';
import '../../viewmodels/paginated_scroll_view_model.dart';
import '../app_structure.dart';
import '../colors.dart';
import '../project_level_data.dart';
import '../size_config.dart';
import 'posts_scroll_view.dart';
import '../../models/profile_model.dart';
import '../../locator.dart';
import '../../services/firestore_service.dart';
import '../../viewmodels/profile_view_model.dart';
import '../../constants/numbers.dart';
import '../../utility/transition.dart';
import '../../utility/profile_picture.dart';
import '../settings/main_settings.dart';
import '../widgets/user_stream_builder.dart';

class Profile extends StatelessWidget {
  const Profile({
    Key key,
    this.uid,
    this.displayBackButton = false,
  }) : super(key: key);

  final String uid;
  final bool displayBackButton;

  @override
  Widget build(BuildContext context) {
    SizeConfig().initSafely(context);
    print('display: $displayBackButton');

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: backgroundGrey,
        body: SafeArea(
          child: Center(
            child: ViewModelBuilder<ProfileViewModel>.reactive(
              viewModelBuilder: () => ProfileViewModel(
                uid: uid,
              ),
              builder: (context, profileModel, _) =>
                  ViewModelBuilder<PaginatedScrollViewModel>.reactive(
                viewModelBuilder: () => PaginatedScrollViewModel(
                    // TODO
                    ),
                onModelReady: (model) => model.listenToItems(),
                builder: (context, postsModel, _) {
                  if (profileModel.isBusy || postsModel.busy) {
                    return CircularProgressIndicator();
                  } else {
                    return CustomScrollView(
                      slivers: [
                        SliverPersistentHeader(
                          floating: true,
                          delegate: ProfileDelegate(
                            expandedHeight: 170 + SizeConfig.v * 12,
                            model: profileModel,
                            displayBackButton: displayBackButton,
                          ),
                        ),
                        PostsScrollView(),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileDelegate extends SliverPersistentHeaderDelegate {
  ProfileDelegate({
    @required this.expandedHeight,
    this.model,
    this.displayBackButton = false,
  });

  final double expandedHeight;
  final ProfileViewModel model;
  final bool displayBackButton;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundGrey,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Stack(
          children: [
            Visibility(
              visible: displayBackButton,
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.grey,
                    size: 35,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: UserInfo(
                model: model.data,
                viewModel: model,
              ),
            ),
            Visibility(
              visible: model.data.isMyProfile,
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => goToSettings(context),
                  child: Icon(
                    Icons.settings,
                    color: Colors.grey,
                    size: 33,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void goToSettings(BuildContext context) {
    Provider.of<NavState>(context, listen: false).setShowNavBar(false);
    Navigator.push(
      context,
      Transition.none(next: Settings()),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => expandedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class UserInfo extends StatelessWidget {
  const UserInfo({Key key, this.model, this.viewModel}) : super(key: key);

  final ProfileModel model;
  final ProfileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(model.photoUrl),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            model.nickname,
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: SizeConfig.v * 3.5,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        model.isMyProfile
            ? MyProfileActionsView(
                uid: model.uid,
                viewModel: viewModel,
              )
            : OtherProfileActionsView(
                uid: model.uid,
                friendStatus: model.friendStatus,
              ),
      ],
    );
  }
}

class MyProfileActionsView extends StatelessWidget {
  const MyProfileActionsView({Key key, this.uid, this.viewModel})
      : super(key: key);

  final String uid;
  final ProfileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                Transition.none(
                  next: FriendsListView(
                    type: ItemType.friendRequest,
                    uid: uid,
                  ),
                ),
              );
            },
            child: Container(
              width: SizeConfig.h * 35,
              height: SizeConfig.v * 6,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Requests',
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        color: Colors.grey[800],
                        fontSize: SizeConfig.h * 4,
                      ),
                    ),
                  ),
                  UserStreamBuilder(
                    uid: uid,
                    builder: (context, snapshot) => snapshot.hasData
                        ? IncomingFriendRequestsView(
                            incomingFriendRequests:
                                snapshot.data.incomingFriendRequests,
                          )
                        : IncomingFriendRequestsView(
                            incomingFriendRequests: 0,
                          ),
                  ),
                  // StreamBuilder(
                  //   stream: viewModel.incomingFriendRequests(),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //       return IncomingFriendRequestsView(
                  //         incomingFriendRequests: snapshot.data
                  //                 .data()['incoming_friend_requests'] ??
                  //             0,
                  //       );
                  //     } else {
                  //       return IncomingFriendRequestsView(
                  //         incomingFriendRequests: 0,
                  //       );
                  //     }
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: GestureDetector(
            onTap: () {
              // Navigate to friends list
              Navigator.push(
                context,
                Transition.bottomToTop(
                  next: FriendsListView(
                    type: ItemType.friend,
                    uid: uid,
                  ),
                ),
              );
            },
            child: Container(
              width: SizeConfig.h * 30,
              height: SizeConfig.v * 6,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Friends',
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        color: Colors.grey[800],
                        fontSize: SizeConfig.h * 4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class IncomingFriendRequestsView extends StatelessWidget {
  IncomingFriendRequestsView({Key key, this.incomingFriendRequests})
      : super(key: key);

  final int incomingFriendRequests;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: incomingFriendRequests != 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
          width: SizeConfig.h * 6,
          height: SizeConfig.h * 6,
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(
            child: Text(
              '$incomingFriendRequests',
              style: GoogleFonts.quicksand(
                color: pureWhite,
                fontSize: SizeConfig.h * 4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OtherProfileActionsView extends StatefulWidget {
  const OtherProfileActionsView(
      {Key key, this.uid, this.friendStatus = 'Friends'})
      : super(key: key);

  /// `uid` of profile owner.
  final String uid;
  final String friendStatus;

  @override
  _OtherProfileActionsViewState createState() =>
      _OtherProfileActionsViewState();
}

class _OtherProfileActionsViewState extends State<OtherProfileActionsView> {
  String _friendStatus;
  final _firestoreService = locator<FirestoreService>();

  /// Based on `_friendStatus`, return the appropriate text.
  String friendButtonText() {
    if (_friendStatus == 'Not friends')
      return 'Add friend';
    else if (_friendStatus == 'Request sent')
      return 'Request sent';
    else if (_friendStatus == 'Friends')
      return 'Friend';
    else
      throw 'Invalid friend status';
  }

  void requestFriend() {
    setState(() {
      _friendStatus = 'Request sent';
    });
    _firestoreService.requestFriend(ProjectLevelData.user.uid, widget.uid);
  }

  void cancelRequest() {
    setState(() {
      _friendStatus = 'Not friends';
    });
    _firestoreService.cancelRequest(ProjectLevelData.user.uid, widget.uid);
  }

  void removeFriend() {
    setState(() {
      _friendStatus = 'Not friends';
    });
    _firestoreService.removeFriend(ProjectLevelData.user.uid, widget.uid);
  }

  @override
  void initState() {
    super.initState();
    _friendStatus = widget.friendStatus;
  }

  @override
  Widget build(BuildContext context) {
    switch (_friendStatus) {
      case 'Not friends':
        {
          return GestureDetector(
            onTap: () {
              requestFriend();
            },
            child: Container(
              width: SizeConfig.h * 40,
              height: SizeConfig.v * 6,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    friendButtonText(),
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        color: Colors.grey[800],
                        fontSize: SizeConfig.h * 4,
                      ),
                    ),
                  ),
                  Visibility(
                    child: Icon(Icons.keyboard_arrow_down),
                    visible: _friendStatus != 'Not friends',
                  ),
                ],
              ),
            ),
          );
        }
      case 'Request sent':
        {
          return PopupMenuButton<String>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem(
                  value: 'Cancel request',
                  child: Text(
                    'Cancel request',
                    style: GoogleFonts.quicksand(),
                  ),
                ),
              ];
            },
            onSelected: (String value) {
              if (value == 'Cancel request') {
                cancelRequest();
              }
            },
            child: Container(
              width: SizeConfig.h * 40,
              height: SizeConfig.v * 6,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    friendButtonText(),
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        color: Colors.grey[800],
                        fontSize: SizeConfig.h * 4,
                      ),
                    ),
                  ),
                  Visibility(
                    child: Icon(Icons.keyboard_arrow_down),
                    visible: _friendStatus != 'Not friends',
                  ),
                ],
              ),
            ),
          );
        }
      case 'Friends':
        {
          return PopupMenuButton<String>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem(
                  value: 'Remove friend',
                  child: Text(
                    'Remove friend',
                    style: GoogleFonts.quicksand(),
                  ),
                ),
              ];
            },
            onSelected: (String value) {
              if (value == 'Remove friend') {
                removeFriend();
              }
            },
            child: Container(
              width: SizeConfig.h * 40,
              height: SizeConfig.v * 6,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    friendButtonText(),
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        color: Colors.grey[800],
                        fontSize: SizeConfig.h * 4,
                      ),
                    ),
                  ),
                  Visibility(
                    child: Icon(Icons.keyboard_arrow_down),
                    visible: _friendStatus != 'Not friends',
                  ),
                ],
              ),
            ),
          );
        }

      default:
        {
          throw 'Invalid friend status.';
        }
    }
  }
}

class FriendsListView extends StatelessWidget {
  const FriendsListView({Key key, this.type, this.uid}) : super(key: key);

  final ItemType type;
  final String uid;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: CustomAppBar(
        type: type,
        height: SizeConfig.v * 10,
        uid: uid,
      ),
      body: Center(
        child: ViewModelBuilder<FriendsListViewModel>.reactive(
          viewModelBuilder: () => FriendsListViewModel(type: type, uid: uid),
          onModelReady: (model) => model.listenToItems(),
          builder: (context, model, child) {
            return UserStreamBuilder(
              uid: uid,
              builder: (context, snapshot) => Visibility(
                visible: visible(snapshot),
                child: ListView.builder(
                  itemCount: model.items.length,
                  itemBuilder: (context, index) => CreationAwareListItem(
                    itemCreated: () {
                      print(index);
                      // Request more data when the created item is at the nth index
                      if (index % itemsPerQuery == 0) {
                        model.requestMoreData();
                      }
                    },
                    child: chooseListItem(model, index),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  bool visible(UserSnapshot snapshot) {
    if (!snapshot.hasData) return false;
    return snapshot.data.incomingFriendRequests != 0 || type == ItemType.friend;
  }

  Widget chooseListItem(model, index) {
    if (type == ItemType.friendRequest) {
      return RequestListItemView(
        model: model.items[index],
        viewModel: model,
      );
    } else {
      return FriendListItemView(model: model.items[index]);
    }
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key key, @required this.height, this.type, this.uid})
      : super(key: key);

  final double height;
  final ItemType type;
  final String uid;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.v * 5, bottom: SizeConfig.v * 2),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.keyboard_arrow_up),
          ),
          Spacer(flex: 3),
          HighlightableButton(
            highlight: type == ItemType.friendRequest,
            text: 'Requests',
            onPressed: () {
              if (type == ItemType.friend) {
                Navigator.pushReplacement(
                  context,
                  Transition.none(
                    next: FriendsListView(
                      type: ItemType.friendRequest,
                      uid: uid,
                    ),
                  ),
                );
              }
            },
          ),
          Spacer(),
          HighlightableButton(
            highlight: type == ItemType.friend,
            text: 'Friends',
            onPressed: () {
              if (type == ItemType.friendRequest) {
                Navigator.pushReplacement(
                  context,
                  Transition.none(
                    next: FriendsListView(
                      type: ItemType.friend,
                      uid: uid,
                    ),
                  ),
                );
              }
            },
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class HighlightableButton extends StatelessWidget {
  const HighlightableButton(
      {Key key, this.highlight, this.text, this.onPressed})
      : super(key: key);

  final bool highlight;
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: highlight ? blue3 : Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      onPressed: () => onPressed(),
      child: Text(
        text,
        style: GoogleFonts.quicksand(
          textStyle: TextStyle(
            color: highlight ? pureWhite : pureBlack,
            fontSize: SizeConfig.h * 4,
          ),
        ),
      ),
    );
  }
}

class FriendsListViewModel extends BaseViewModel {
  FriendsListViewModel({this.type, this.uid});

  final ItemType type;
  final String uid;

  final FirestoreService _firestoreService = locator<FirestoreService>();

  List<dynamic> _items = List<dynamic>();
  List<dynamic> get items => _items;

  int _counter = 0;
  int get counter => _counter;

  void listenToItems() {
    setBusy(true);

    _firestoreService.listenToItemsRealTime(uid, type).listen((itemsData) {
      List<dynamic> updatedItems = itemsData;
      if (updatedItems != null && updatedItems.length > 0) {
        _items = updatedItems;
        notifyListeners();
      }

      setBusy(false);
    });
    print('listening complete');
  }

  void requestMoreData() => _firestoreService.requestMoreData(uid, type);

  Stream<DocumentSnapshot> incomingFriendRequests() {
    return _firestoreService.userDataStream(uid);
  }

  void handleRequestResponse(
      String accepterUid, RequestListItemModel requesterModel, bool accept) {
    _firestoreService.handleRequestResponse(
        accepterUid, requesterModel, accept);
    notifyListeners();
  }
}

class RequestListItemView extends StatelessWidget {
  RequestListItemView({Key key, this.model, this.viewModel}) : super(key: key);

  final RequestListItemModel model;
  final FriendsListViewModel viewModel;

  void handleRequestResponse(BuildContext context, bool accept) {
    viewModel.handleRequestResponse(ProjectLevelData.user.uid, model, accept);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProfilePicture(
                uid: model.requesterUid,
                photoUrl: model.photoUrl,
                radius: 20,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  'Would you like to be friends with ${model.nickname}?',
                  softWrap: true,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: pureBlack,
                      fontSize: SizeConfig.h * 5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  model.timeSince,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: pureBlack,
                      fontSize: SizeConfig.h * 4,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SizedBox(
                width: SizeConfig.h * 20,
                child: RaisedButton(
                  color: purple3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  onPressed: () => handleRequestResponse(context, true),
                  child: Text(
                    'Yes',
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        color: pureWhite,
                        fontSize: SizeConfig.h * 4,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SizedBox(
                width: SizeConfig.h * 20,
                child: RaisedButton(
                  color: Colors.grey[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  onPressed: () => handleRequestResponse(context, false),
                  child: Text(
                    'No',
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(fontSize: SizeConfig.h * 4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider(thickness: 2, indent: 16.0, endIndent: 16.0),
      ],
    );
  }
}

class RequestListItemProvider extends ChangeNotifier {
  bool _visible = true;
  bool get visible => _visible;

  void makeInvisible() {
    _visible = false;
    notifyListeners();
  }
}

class RequestListItemModel {
  RequestListItemModel({
    this.requesterUid,
    this.photoUrl,
    this.nickname,
    this.timeSince,
  });

  final String requesterUid;
  final String photoUrl;
  final String nickname;
  final String timeSince;

  static RequestListItemModel fromMap(
      Map<String, dynamic> map, String documentId) {
    return RequestListItemModel(
      requesterUid: documentId,
      photoUrl: map['photoUrl'],
      nickname: map['nickname'],
      timeSince: getTimeSince(map['timestamp']),
    );
  }

  /// Convert `timestamp` into timeSince.
  static String getTimeSince(Timestamp timestamp) {
    DateTime myDateTime = DateTime.parse(timestamp.toDate().toString());
    return Jiffy(myDateTime).fromNow();
  }
}

class FriendListItemView extends StatelessWidget {
  const FriendListItemView({Key key, this.model}) : super(key: key);

  final FriendListItemModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              // child: CircleAvatar(
              //   radius: 20.0,
              //   backgroundImage: NetworkImage(model.photoUrl),
              // ),
              child: ProfilePicture(
                uid: model.uid,
                photoUrl: model.photoUrl,
                radius: 20,
              ),
            ),
            Text(
              model.nickname,
              softWrap: true,
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  color: pureBlack,
                  fontSize: SizeConfig.h * 5,
                ),
              ),
            ),
          ],
        ),
        Divider(thickness: 2, indent: 16.0, endIndent: 16.0),
      ],
    );
  }
}

class FriendListItemModel {
  FriendListItemModel({
    this.uid,
    this.photoUrl,
    this.nickname,
  });

  final String uid;
  final String photoUrl;
  final String nickname;

  static FriendListItemModel fromMap(
      Map<String, dynamic> map, String documentId) {
    return FriendListItemModel(
      uid: documentId,
      photoUrl: map['photoUrl'],
      nickname: map['nickname'],
    );
  }
}
