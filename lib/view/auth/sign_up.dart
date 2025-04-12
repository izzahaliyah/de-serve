// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:deserve/view/auth/phone_number_verification.dart';
// import 'package:deserve/view/auth/enter_pin_page.dart';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final _phoneController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   String? _verificationId;

//   void _submit() async {
//     if (_formKey.currentState!.validate()) {
//       String phone = _phoneController.text.trim();

//       // Send OTP to the user's phone
//       await FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: phone,
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           // If auto-verification is successful, sign in the user
//           await FirebaseAuth.instance.signInWithCredential(credential);
//           // After successful sign-in, push to the next page
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => PhoneVerificationPage(phoneNumber: phone),
//             ),
//           );
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           // Handle error
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(e.message ?? 'Verification Failed')),
//           );
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           // Save the verificationId for later use
//           _verificationId = verificationId;
//           _showOTPDialog(verificationId);
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           // Handle timeout (optional)
//         },
//       );
//     }
//   }

//   void _showOTPDialog(String verificationId) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         TextEditingController otpController = TextEditingController();

//         return AlertDialog(
//           title: const Text("Enter OTP"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: otpController,
//                 decoration: const InputDecoration(hintText: "Enter OTP"),
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             ElevatedButton(
//               onPressed: () async {
//                 String otp = otpController.text.trim();
//                 PhoneAuthCredential credential = PhoneAuthProvider.credential(
//                   verificationId: verificationId,
//                   smsCode: otp,
//                 );

//                 // Sign in with the OTP
//                 try {
//                   await FirebaseAuth.instance.signInWithCredential(credential);
//                   // Store user data in Firestore (for new users)
//                   FirebaseFirestore.instance
//                       .collection('users')
//                       .doc(FirebaseAuth.instance.currentUser!.uid)
//                       .set({
//                     'phone': FirebaseAuth.instance.currentUser!.phoneNumber,
//                     'createdAt': Timestamp.now(),
//                   });
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => EnterPinPage(
//                           phoneNumber:
//                               FirebaseAuth.instance.currentUser!.phoneNumber!),
//                     ),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text('Invalid OTP, please try again')),
//                   );
//                 }
//               },
//               child: const Text('Submit OTP'),
//             ),
//           ],
//         );
//       },
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
//       appBar: AppBar(
//         title: const Text('Register with Phone'),
//         backgroundColor: const Color(0xFFA8BBA2), // Dusty green
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 'Enter your phone number',
//                 style: TextStyle(fontSize: 20),
//               ),
//               const SizedBox(height: 20),
//               TextFormField(
//                 controller: _phoneController,
//                 keyboardType: TextInputType.phone,
//                 decoration: const InputDecoration(
//                   hintText: 'e.g. +60123456789',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.phone),
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
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFA8BBA2),
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                 ),
//                 child: const Text('Send OTP', style: TextStyle(fontSize: 16)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:deserve/presenter/auth_presenter.dart';
import 'enter_pin_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> implements AuthViewContract {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AuthPresenter _presenter;
  String? _verificationId;

  @override
  void initState() {
    super.initState();
    _presenter = AuthPresenter(this);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _presenter.sendOTP(_phoneController.text.trim());
    }
  }

  void _showOTPDialog() {
    final otpController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enter OTP"),
        content: TextField(
          controller: otpController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "Enter OTP"),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              _presenter.verifyOTP(_verificationId!, otpController.text.trim());
              Navigator.of(context).pop();
            },
            child: const Text("Submit OTP"),
          ),
        ],
      ),
    );
  }

  @override
  void onAutoVerified() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EnterPinPage(phoneNumber: _phoneController.text),
      ),
    );
  }

  @override
  void onCodeSent(String verificationId) {
    _verificationId = verificationId;
    _showOTPDialog();
  }

  @override
  void onVerificationFailed(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }

  @override
  void onOTPVerified() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EnterPinPage(phoneNumber: _phoneController.text),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register with Phone")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text("Enter your phone number"),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: "+60123456789",
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  } else if (!RegExp(r'^\+60[0-9]{8,10}$').hasMatch(value)) {
                    return 'Enter a valid Malaysian phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Send OTP"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
