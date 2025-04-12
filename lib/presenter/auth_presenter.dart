import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_model.dart';

abstract class AuthViewContract {
  void onCodeSent(String verificationId);
  void onVerificationFailed(String error);
  void onAutoVerified();
  void onOTPVerified();
}

class AuthPresenter {
  final AuthViewContract _view;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthPresenter(this._view);

  void sendOTP(String phoneNumber) {
    _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        _view.onAutoVerified();
      },
      verificationFailed: (FirebaseAuthException e) {
        _view.onVerificationFailed(e.message ?? "Verification failed");
      },
      codeSent: (String verificationId, int? resendToken) {
        _view.onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> verifyOTP(String verificationId, String smsCode) async {
    try {
      final credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      await _auth.signInWithCredential(credential);

      final user = UserModel(
        phone: _auth.currentUser!.phoneNumber!,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set(user.toMap());

      _view.onOTPVerified();
    } catch (e) {
      _view.onVerificationFailed('Invalid OTP');
    }
  }
}
