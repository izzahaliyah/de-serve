import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'enter_pin_page.dart';

class PhoneVerificationPage extends StatefulWidget {
  final String phoneNumber;

  const PhoneVerificationPage({super.key, required this.phoneNumber});

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  String? _verificationId;
  bool _isOTPSent = false;
  bool _isLoading = false;

  // Timer
  int _resendCountdown = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _verifyPhoneNumber();
  }

  void _startResendTimer() {
    _resendCountdown = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown == 0) {
        timer.cancel();
      } else {
        setState(() {
          _resendCountdown--;
        });
      }
    });
  }

  void _verifyPhoneNumber() async {
    setState(() {
      _isLoading = true;
      _isOTPSent = false;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        _onVerificationSuccess();
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Verification failed')),
        );
        setState(() => _isLoading = false);
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _isOTPSent = true;
          _isLoading = false;
        });
        _startResendTimer();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void _verifyOTP() async {
    if (_verificationId == null || _otpController.text.trim().isEmpty) return;

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: _otpController.text.trim(),
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      _onVerificationSuccess();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP, please try again')),
      );
    }
  }

  void _onVerificationSuccess() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'phone': user.phoneNumber,
        'createdAt': Timestamp.now(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EnterPinPage(phoneNumber: user.phoneNumber!),
        ),
      );
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Phone"),
        backgroundColor: const Color(0xFFA8BBA2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter the OTP sent to ${widget.phoneNumber}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter OTP',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _verifyOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA8BBA2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                    child: const Text('Verify', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 20),
                  _resendCountdown > 0
                      ? Text("Resend OTP in $_resendCountdown seconds")
                      : TextButton(
                          onPressed: _verifyPhoneNumber,
                          child: const Text(
                            "Resend OTP",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                ],
              ),
      ),
    );
  }
}
