// import 'dart:async';
// import 'package:deserve/signup/otp_presenter.dart';
// import 'package:flutter/material.dart';
// import '../view/auth/enter_pin_page.dart';

// class PhoneVerificationPage extends StatefulWidget {
//   final String phoneNumber;

//   const PhoneVerificationPage({super.key, required this.phoneNumber});

//   @override
//   State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
// }

// class _PhoneVerificationPageState extends State<PhoneVerificationPage>
//     implements AuthViewContract {
//   final TextEditingController _otpController = TextEditingController();
//   String? _verificationId;
//   bool _isOTPSent = false;
//   bool _isLoading = false;

//   // Timer
//   int _resendCountdown = 30;
//   Timer? _timer;

//   late AuthPresenter _presenter;

//   @override
//   void initState() {
//     super.initState();
//     _presenter = AuthPresenter(this); // Initialize the presenter
//     _presenter.sendOTP(widget.phoneNumber); // Send OTP using the presenter
//   }

//   void _startResendTimer() {
//     _resendCountdown = 30;
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_resendCountdown == 0) {
//         timer.cancel();
//       } else {
//         setState(() {
//           _resendCountdown--;
//         });
//       }
//     });
//   }

//   @override
//   void onCodeSent(String verificationId) {
//     setState(() {
//       _verificationId = verificationId;
//       _isOTPSent = true;
//       _isLoading = false;
//     });
//     _startResendTimer();
//   }

//   @override
//   void onOTPVerified() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => EnterPinPage(phoneNumber: widget.phoneNumber),
//       ),
//     );
//   }

//   @override
//   void onAutoVerified() {
//     onOTPVerified(); // If auto-verification succeeds, proceed to OTP verification success
//   }

//   @override
//   void onVerificationFailed(String error) {
//     setState(() => _isLoading = false);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(error)),
//     );
//   }

//   void _verifyOTP() {
//     if (_verificationId == null || _otpController.text.trim().isEmpty) return;
//     _presenter.verifyOTP(_verificationId!,
//         _otpController.text.trim()); // Use presenter for OTP verification
//   }

//   @override
//   void dispose() {
//     _otpController.dispose();
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Verify Phone"),
//         backgroundColor: const Color(0xFFA8BBA2),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Enter the OTP sent to ${widget.phoneNumber}',
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 18),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _otpController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       hintText: 'Enter OTP',
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _verifyOTP,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFA8BBA2),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 40, vertical: 15),
//                     ),
//                     child: const Text('Verify', style: TextStyle(fontSize: 16)),
//                   ),
//                   const SizedBox(height: 20),
//                   _resendCountdown > 0
//                       ? Text("Resend OTP in $_resendCountdown seconds")
//                       : TextButton(
//                           onPressed: () {
//                             _presenter
//                                 .sendOTP(widget.phoneNumber); // Resend OTP
//                           },
//                           child: const Text(
//                             "Resend OTP",
//                             style: TextStyle(fontSize: 16),
//                           ),
//                         ),
//                 ],
//               ),
//       ),
//     );
//   }
// }

import 'package:deserve/view/home/home_view.dart';
import 'package:deserve/view/home/main_home_page.dart';
import 'package:flutter/material.dart';
import '../set_pin/set_pin_view.dart';
import 'otp_presenter.dart';

class OTPView extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final bool isLogin;

  OTPView({
    required this.verificationId,
    required this.phoneNumber,
    this.isLogin = false, //default is signup
  });

  @override
  _OTPViewState createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> implements OTPViewContract {
  late OTPPresenter _presenter;
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _presenter = OTPPresenter(this);
  }

  void _verifyCode() {
    final code = _otpController.text.trim();
    _presenter.verifyCode(widget.verificationId, code);
  }

  @override
  void onVerificationSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Verification successful!')),
    );

    if (widget.isLogin) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainHomePage()),
        (route) => false,
      );
    } else {
      // Navigate to the SetPinView
      Navigator.pushReplacementNamed(context, '/setPin'
          // MaterialPageRoute(builder: (_) => SetPinView()),
          );
    }
  }

  @override
  void onError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Code sent to ${widget.phoneNumber}'),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'OTP Code',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyCode,
              child: Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
