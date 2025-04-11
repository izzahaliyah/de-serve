import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

class ProfilePage extends StatefulWidget {
  final String phoneNumber;

  const ProfilePage({super.key, required this.phoneNumber});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _selectedGender;

  void _submitProfile() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final phone = widget.phoneNumber;
      final gender = _selectedGender;

      // Store this information in your database or state
      print("Name: $name");
      print("Phone: $phone");
      print("Email: $email");
      print("Gender: $gender");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );

      // Navigate to homepage or dashboard
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) =>
            false, // This removes all previous routes including the signup flow
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8BBA2),
      appBar: AppBar(
        title: const Text('Update Profile'),
        backgroundColor: const Color(0xFFA8BBA2),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Tell us more about yourself',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 30),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Full Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 20),

              // Phone (readonly)
              TextFormField(
                initialValue: widget.phoneNumber,
                readOnly: true,
                decoration: _inputDecoration('Phone Number'),
              ),
              const SizedBox(height: 20),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: _inputDecoration('Email Address'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your email' : null,
              ),
              const SizedBox(height: 20),

              // Gender Dropdown
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: _inputDecoration('Gender'),
                dropdownColor: Colors.white,
                items: [
                  'Male',
                  'Female',
                  'Prefer not to say',
                ]
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select your gender' : null,
              ),
              const SizedBox(height: 40),

              // Submit Button
              ElevatedButton(
                onPressed: _submitProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFA8BBA2),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      filled: true,
      fillColor: Colors.white24,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
