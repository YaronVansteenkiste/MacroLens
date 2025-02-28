import 'package:flutter/material.dart';
import 'package:macro_lens/barcode_scanner.dart';
import 'package:macro_lens/dashboard_page.dart';
import 'package:macro_lens/home_content.dart';
import 'package:macro_lens/profile_page.dart';
import 'bottom_nav_bar.dart';
import 'login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: firebaseOptions);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MacroLens',
      theme: ThemeData(
        primaryColor: const Color(0xFF4A90E2),
        hintColor: const Color(0xFF00BCD4),
        scaffoldBackgroundColor: const Color.fromARGB(255, 21, 27, 35),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF1E1E1E),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        } else if (snapshot.hasData) {
          return const MyHomePage(title: 'Home Page');
        } else {
          return const LoginPage();
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _tabIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

  void _onTabChanged(int index) {
    setState(() {
      _tabIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 21, 27, 35),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _tabIndex = index;
          });
        },
        children: [
          DashboardPage(),
          HomeContent(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: buildBottomNavBar(_tabIndex, _pageController, onTabChanged: _onTabChanged),
    );
  }
}

Widget yourFirstScreen() {
  return HomeContent();
}

Widget yourSecondScreen() {
  return BarcodeScanner();
}

Widget yourThirdScreen() {
  return ProfilePage();
}