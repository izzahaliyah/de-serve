import 'package:deserve/view/home/main_home_page.dart';
import 'package:deserve/view/profile/profile_completion_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'view/login/login.dart';
import 'view/home/home_view.dart';
import 'view/profile/profile_view.dart';
import 'view/screens/splash_screen.dart';
import 'view/screens/welcome_view.dart';
import 'view/set_pin/set_pin_view.dart';
import 'view/otp/otp_view.dart';
import 'view/signup/signup_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deserve',
      theme: ThemeData(
        primaryColor: const Color(0xFFA8BBA2),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFA8BBA2),
        ),
      ),
      home: FirebaseAuth.instance.currentUser != null
          ? MainHomePage()
          : SplashScreen(),
      routes: {
        // '/': (context) => const SplashScreen(),
        '/welcome': (context) => WelcomeView(),
        '/signup': (context) => SignUpView(),
        '/otp': (context) => OTPView(verificationId: '', phoneNumber: ''),
        '/setPin': (context) => SetPinView(),
        '/profileCompletion': (context) => ProfileCompletionView(),
        '/login': (context) => Login(),
        '/home': (context) => HomeView(),
        // '/profile': (context) => const ProfileView(),
      },
    );
  }
}
