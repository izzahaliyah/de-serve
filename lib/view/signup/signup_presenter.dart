import 'package:firebase_auth/firebase_auth.dart';

abstract class SignUpViewContract {
  void onCodeSent(String verificationId);
  void onError(String message);
}

class SignUpPresenter {
  final SignUpViewContract view;
  final FirebaseAuth _auth = FirebaseAuth.instance;

//constructor
  SignUpPresenter(this.view) {
    _auth.setSettings(appVerificationDisabledForTesting: true);
  }

  void sendCode(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Optional: auto sign-in
        },
        verificationFailed: (FirebaseAuthException e) {
          view.onError(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          print('Verification ID sent: $verificationId'); // Debugging
          view.onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      view.onError(e.toString());
    }
  }
}
