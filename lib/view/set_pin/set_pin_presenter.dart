import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class SetPinViewContract {
  void onPinSaved();
  void onError(String message);
}

class SetPinPresenter {
  final SetPinViewContract view;

  SetPinPresenter(this.view);

  Future<void> savePin(String pin) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('user').doc(user.uid).set({
          'pin': pin,
        }, SetOptions(merge: true));

        view.onPinSaved();
      } else {
        view.onError("User not authenticated.");
      }
    } catch (e) {
      view.onError("Failed to save PIN: ${e.toString()}");
    }
  }
}
