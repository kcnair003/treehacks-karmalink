import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';

import '../locator.dart';
import '../services/firestore_service.dart';
import '../models/profile_model.dart';

class ProfileViewModel extends FutureViewModel<ProfileModel> {
  final String uid;
  final _firestoreService = locator<FirestoreService>();

  ProfileViewModel({this.uid});

  Future<ProfileModel> futureToRun() =>
      _firestoreService.constructProfileModel(uid);

  Stream<DocumentSnapshot> incomingFriendRequests() {
    return _firestoreService.userDataStream(uid);
  }
}
