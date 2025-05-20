import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_completion_contract.dart';

class ProfileCompletionViewPresenter {
  final ProfileCompletionViewContract view;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _userCollection = 'user';

  ProfileCompletionViewPresenter(this.view);

  Future<void> saveProfile(
      String name, String email, String gender, String? role) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // await _firestore.collection('user').doc(user.uid).update({
        final profileData = {
          'name': name,
          'email': email,
          'gender': gender,
          'role': role ?? 'Customer',
        };

        await _firestore
            .collection(_userCollection)
            .doc(user.uid)
            .set(profileData, SetOptions(merge: true));
        view.onProfileSaved();
      } else {
        view.onError('User not authenticated');
      }
    } catch (e) {
      view.onError(e.toString());
    }
  }
}
