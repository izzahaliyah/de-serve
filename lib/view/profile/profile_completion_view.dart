import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home/main_home_page.dart';
import '../profile/profile_completion_presenter.dart';
import '../profile/profile_completion_contract.dart';
import '../home/home_view.dart';

class ProfileCompletionView extends StatefulWidget {
  const ProfileCompletionView({Key? key}) : super(key: key);

  @override
  State<ProfileCompletionView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<ProfileCompletionView>
    implements ProfileCompletionViewContract {
  final _formKey = GlobalKey<FormState>();
  late ProfileCompletionViewPresenter _presenter;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _gender = 'Male';
  String _phoneNumber = '';
  String? _selectedRole = 'Customer';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _presenter = ProfileCompletionViewPresenter(this);
    _fetchPhoneNumber();
  }

  void _fetchPhoneNumber() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _phoneNumber = user.phoneNumber ?? '';
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      _presenter.saveProfile(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _gender,
        _selectedRole,
      );
    }
  }

  @override
  void onProfileSaved() {
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved successfully!')),
    );
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainHomePage()),
        (route) => false,
      );
    });
  }

  @override
  void onError(String message) {
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');

    return Scaffold(
      appBar: AppBar(title: const Text('Complete Your Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isSaving
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter your name'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: _phoneNumber,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your email';
                        }
                        if (!emailRegex.hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _gender,
                      decoration: const InputDecoration(labelText: 'Gender'),
                      items: ['Male', 'Female', 'Other']
                          .map((gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _gender = value);
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration:
                          const InputDecoration(labelText: 'Select Role'),
                      onChanged: (newRole) {
                        setState(() => _selectedRole = newRole);
                      },
                      items: ['Customer', 'Service Provider']
                          .map((role) => DropdownMenuItem(
                                value: role,
                                child: Text(role),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveProfile,
                        child: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.0,
                                ),
                              )
                            : const Text('Save Profile'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
