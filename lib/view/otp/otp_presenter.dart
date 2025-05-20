import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class OTPViewContract {
  void onVerificationSuccess();
  void onError(String message);
}

class OTPPresenter {
  final OTPViewContract view;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  OTPPresenter(this.view);

  void verifyCode(String verificationId, String smsCode) async {
    try {
      print('Using verificationId: $verificationId'); //debug
      print('Entered OTP code: $smsCode'); //debug

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        //check user exist in firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('user').doc(user.uid).get();

        if (!userDoc.exists) {
          //user not exist, create new
          await _firestore.collection('user').doc(user.uid).set({
            'phoneNumber': user.phoneNumber,
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true)); //merge to avoid overwrite if exists
        }
        view.onVerificationSuccess();
      } else {
        view.onError('User authentication failed.');
      }
    } catch (e) {
      print('Verification Error: $e');
      view.onError('Invalid OTP or verification failed.');
      // view.onError(e.toString());
    }
  }
}
