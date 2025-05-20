import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/welcome_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    // Navigate to Welcome Screen after logout
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeView()),
      (route) => false, // Removes all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${user?.phoneNumber ?? "User"}!',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            const Text('This is your home screen.'),
          ],
        ),
      ),
    );
  }
}
