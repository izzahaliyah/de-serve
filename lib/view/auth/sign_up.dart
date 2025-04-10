import 'package:deserve/view/auth/enter_pin_page.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // void _register() {
  //   if (_formKey.currentState!.validate()) {
  //     String phoneNumber = _phoneController.text.trim();
  //     // Call Firebase or API to register using phone number
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Phone Number: $phoneNumber')),
  //     );
  //   }
  // }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      String phone = _phoneController.text.trim();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EnterPinPage(phoneNumber: phone),
        ),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register with Phone'),
        backgroundColor: Color(0xFFA8BBA2), // Dusty green
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter your phone number',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'e.g. +60123456789',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
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
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFA8BBA2),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text('Register', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
