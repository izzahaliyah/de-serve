import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'view/screens/splash_screen.dart';
import 'view/screens/welcome_screen.dart';
import 'view/auth/sign_up.dart';
import 'view/auth/login.dart';
// import 'view/screens/home_screen.dart';
// import 'view/auth/register.dart';

// void main() {
//   runApp(MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    runApp(MyApp());
  } catch (e) {
    print('Firebase initialization error: $e');
  }
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'De-Serve',
      theme: ThemeData(
        primaryColor: Color(0xFFA8BBA2),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFA8BBA2),
        ),
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
