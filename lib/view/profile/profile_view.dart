import 'package:deserve/view/profile/profile_presenter.dart';
import 'package:deserve/view/profile/profile_view_contract.dart';
import 'package:flutter/material.dart';
import '../../model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    implements ProfileViewContract {
  late ProfilePresenter _presenter;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _genderController;
  late TextEditingController _phoneController;
  bool _isLoading = true;
  String? _role;

  UserModel? _profile;

  @override
  void initState() {
    super.initState();
    _presenter = ProfilePresenter(this);
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _genderController = TextEditingController();
    _phoneController = TextEditingController();
    _presenter.getProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _genderController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void showProfile(UserModel profile) {
    setState(() {
      _profile = profile;
      _nameController.text = profile.name ?? '';
      _emailController.text = profile.email ?? '';
      _genderController.text = profile.gender ?? '';
      _phoneController.text = profile.phoneNumber;
      _role = profile.role ?? 'Not Set';
      _isLoading = false;
    });
  }

  @override
  void onUpdateSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  @override
  void onError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $message')),
    );
  }

  void _updateProfile() {
    if (_profile != null) {
      final updatedProfile = UserModel(
        phoneNumber: _profile!.phoneNumber,
        createdAt: _profile!.createdAt,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        gender: _genderController.text.trim(),
        role: _role,
      );

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _presenter.updateProfile(user.uid, updatedProfile);
      } else {
        onError("User not authenticated.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (_profile == null) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Role: $_role'),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _genderController.text.isNotEmpty
                  ? _genderController.text
                  : null,
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
              ],
              onChanged: (value) {
                setState(() {
                  _genderController.text = value!;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Select Gender',
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
