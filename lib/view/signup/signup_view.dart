// import 'package:flutter/material.dart';
// import 'package:deserve/presenter/auth_presenter.dart';
// import '../view/auth/enter_pin_page.dart';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> implements AuthViewContract {
//   final _phoneController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   late AuthPresenter _presenter;
//   String? _verificationId;

//   @override
//   void initState() {
//     super.initState();
//     _presenter = AuthPresenter(this);
//   }

//   void _submit() {
//     if (_formKey.currentState!.validate()) {
//       _presenter.sendOTP(_phoneController.text.trim());
//     }
//   }

//   void _showOTPDialog() {
//     final otpController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Enter OTP"),
//         content: TextField(
//           controller: otpController,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(hintText: "Enter OTP"),
//         ),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               _presenter.verifyOTP(_verificationId!, otpController.text.trim());
//               Navigator.of(context).pop();
//             },
//             child: const Text("Submit OTP"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void onAutoVerified() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => EnterPinPage(phoneNumber: _phoneController.text),
//       ),
//     );
//   }

//   @override
//   void onCodeSent(String verificationId) {
//     _verificationId = verificationId;
//     _showOTPDialog();
//   }

//   @override
//   void onVerificationFailed(String error) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
//   }

//   @override
//   void onOTPVerified() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => EnterPinPage(phoneNumber: _phoneController.text),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _phoneController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Register with Phone")),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               const SizedBox(height: 30),
//               const Text("Enter your phone number"),
//               const SizedBox(height: 20),
//               TextFormField(
//                 controller: _phoneController,
//                 keyboardType: TextInputType.phone,
//                 decoration: const InputDecoration(
//                   hintText: "+60123456789",
//                   prefixIcon: Icon(Icons.phone),
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Phone number is required';
//                   } else if (!RegExp(r'^\+60[0-9]{8,10}$').hasMatch(value)) {
//                     return 'Enter a valid Malaysian phone number';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: _submit,
//                 child: const Text("Send OTP"),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:deserve/view/signup/otp_view.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../otp/otp_view.dart';
import 'signup_presenter.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> implements SignUpViewContract {
  late SignUpPresenter _presenter;
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    _presenter = SignUpPresenter(this);
  }

  void _submitPhoneNumber() {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a phone number.')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _timeoutTimer = Timer(Duration(seconds: 60), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request timeout. Please try again.')),
        );
      }
    });

    _presenter.sendCode(phone);
  }

  @override
  void onCodeSent(String verificationId) {
    _timeoutTimer?.cancel();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        // builder: (_) => OTPView(
        builder: (context) => OTPView(
          verificationId: verificationId,
          phoneNumber: _phoneController.text.trim(),
        ),
      ),
      // You can navigate to OTP verification screen here
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Code sent to $verificationId')),
    );
  }

  @override
  void onError(String message) {
    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phone Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: '+60123456789',
              ),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitPhoneNumber,
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
