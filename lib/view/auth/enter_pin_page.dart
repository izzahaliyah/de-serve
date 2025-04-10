import 'package:flutter/material.dart';

import '../profile/profile_page.dart';

class EnterPinPage extends StatefulWidget {
  final String phoneNumber;

  EnterPinPage({required this.phoneNumber});

  @override
  _EnterPinPageState createState() => _EnterPinPageState();
}

class _EnterPinPageState extends State<EnterPinPage> {
  final TextEditingController _pinController = TextEditingController();

  void _submitPin() {
    String pin = _pinController.text.trim();

    if (pin.length < 4 || pin.length > 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PIN must be between 4 to 6 digits')),
      );
    } else {
      // Save the PIN to a database or secure storage here

      print('Phone: ${widget.phoneNumber}, PIN: $pin');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PIN registered successfully!')),
      );

      // // Navigate to next page or back to login
      // Navigator.pushNamed(context, '/login');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(phoneNumber: widget.phoneNumber),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA8BBA2),
      appBar: AppBar(
        title: Text('Set Your PIN'),
        backgroundColor: Color(0xFFA8BBA2),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Create a PIN for ${widget.phoneNumber}',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 30),
            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white24,
                hintText: 'Enter 4 to 6 digit PIN',
                hintStyle: TextStyle(color: Colors.white70),
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitPin,
              child: Text('Save PIN'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFFA8BBA2),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
