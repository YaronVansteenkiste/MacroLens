import 'package:flutter/material.dart';
import 'package:macro_lens/barcode_scanner.dart';
import 'package:macro_lens/dashboard_page.dart';
import 'package:macro_lens/home_content.dart';
import 'package:macro_lens/profile_page.dart';
import 'bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const MyHomePage(title: 'Home Page'),
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