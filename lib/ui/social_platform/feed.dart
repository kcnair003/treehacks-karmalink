import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import '../../services/firestore_service.dart';
import '../../viewmodels/paginated_scroll_view_model.dart';
import '../colors.dart';
import '../project_level_data.dart';
import 'create_post.dart';
import '../../utility/transition.dart';
import 'posts_scroll_view.dart';
import 'profile.dart';
import '../../utility/profile_picture.dart';

double topPadding;

class Feed extends StatelessWidget {
  Feed({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    topPadding = data.padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: backgroundGrey,
        body: Center(
          child: ViewModelBuilder<PaginatedScrollViewModel>.reactive(
            viewModelBuilder: () => PaginatedScrollViewModel(
              type: ItemType.post,
            ),
            onModelReady: (model) => model.listenToItems(),
            builder: (context, model, child) => model.busy
                ? CircularProgressIndicator()
                : CustomScrollView(
                    slivers: [
                      SliverPersistentHeader(
                        floating: true,
                        delegate: FeedAppBarDelegate(
                          expandedHeight: 60 + topPadding,
                        ),
                      ),
                      PostsScrollView(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// class FeedAppBarDelegate extends SliverPersistentHeaderDelegate {
//   FeedAppBarDelegate({
//     @required this.expandedHeight,
//     /* this.ancestor */
//   });

//   final double expandedHeight;
//   // final Widget ancestor;

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(25),
//           bottomRight: Radius.circular(25),
//         ),
//         boxShadow: <BoxShadow>[
//           BoxShadow(
//             color: Colors.grey[300],
//             blurRadius: 8.0,
//             spreadRadius: 4.0,
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: EdgeInsets.only(top: topPadding + 8, bottom: 8),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(width: 16),
//             Text(
//               'Community',
//               style: TextStyle(
//                 // color: purple2,
//                 fontSize: 30,
//                 fontWeight: FontWeight.w800,
//                 foreground: Paint()
//                   ..shader = LinearGradient(
//                     colors: [
//                       orange2,
//                       purple2,
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ).createShader(Rect.fromLTWH(0.0, 0.0, 250, 100)),
//               ),
//             ),
//             Spacer(),
//           ],
//         ),
//       ),
//     );
//   }

//   void goToCreatePost(BuildContext context) {
//     Navigator.push(
//       context,
//       Transition.bottomToTop(
//         next: CreatePost(),
//       ),
//     );
//   }

//   Shadow boxShadow() {
//     return BoxShadow(
//       color: Colors.grey.withOpacity(.5),
//       blurRadius: 5,
//     );
//   }

//   @override
//   double get maxExtent => expandedHeight + topPadding;

//   @override
//   double get minExtent => expandedHeight + topPadding;

//   @override
//   bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
// }

class FeedAppBarDelegate extends SliverPersistentHeaderDelegate {
  FeedAppBarDelegate({@required this.expandedHeight, this.ancestor});

  final double expandedHeight;
  final Widget ancestor;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: expandedHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 8.0,
            spreadRadius: 4.0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: topPadding + 8, bottom: 8),
        child: Row(
          children: [
            SizedBox(width: 16),
            Text(
              'Community',
              style: TextStyle(
                // color: purple2,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: [
                      orange2,
                      purple2,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(Rect.fromLTWH(0.0, 0.0, 250, 100)),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  void goToCreatePost(BuildContext context) {
    Navigator.push(
      context,
      Transition.bottomToTop(
        next: CreatePost(),
      ),
    );
  }

  Shadow boxShadow() {
    return BoxShadow(
      color: Colors.grey.withOpacity(.5),
      blurRadius: 5,
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => expandedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
