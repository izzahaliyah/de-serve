import 'package:flutter/material.dart';
import 'view/screens/splash_screen.dart';
import 'view/screens/welcome_screen.dart';
import 'view/auth/sign_up.dart';
import 'view/auth/login.dart';
import 'view/screens/home_screen.dart';
// import 'view/auth/register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'De-Serve',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // home: HomePage(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/welcome': (context) => WelcomePage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        // '/home': (context) => HomePage(),
      },
    );
  }
}

// Temporary placeholder pages
// class LoginPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: Center(child: Text("Login Page")));
//   }
// }

// class SignUpPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: Center(child: Text("Sign Up Page")));
//   }
// }

//biar dulu
// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Page'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Text(
//           'Welcome to Flutter!',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }
