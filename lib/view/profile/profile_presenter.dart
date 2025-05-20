import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deserve/view/profile/profile_view_contract.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/user_model.dart';
// import 'profile_view_contract.dart';

class ProfilePresenter {
  final ProfileViewContract view;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  ProfilePresenter(this.view);

  Future<void> getProfile() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('user').doc(user.uid).get();
        print('Firestore data: ${doc.data()}'); //debug
        if (doc.exists) {
          final profile = UserModel.fromMap(doc.data()!);
          view.showProfile(profile);
        } else {
          view.onError('Profile not found.');
        }
      }
    } catch (e) {
      view.onError(e.toString());
    }
  }

  Future<void> updateProfile(String userId, UserModel profile) async {
    try {
      print('Calling updateProfile for $userId'); // debug to check
      print(
          'Updating profile with: ${profile.toMap()}'); // debug to confirm data

      await _firestore.collection('user').doc(userId).update(profile.toMap());

      print('Firestore update done');
      view.onUpdateSuccess();
    } catch (e) {
      print('Error updating: $e'); // debug error
      view.onError(e.toString());
    }
  }
}
