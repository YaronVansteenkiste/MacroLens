import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';

import 'dashboard_page.dart';
import 'profile_page.dart';
import 'home_content.dart';

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
  int get tabIndex => _tabIndex;
  set tabIndex(int v) {
    _tabIndex = v;
    setState(() {});
  }

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _tabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CircleNavBar(
        activeIcons: const [
          Icon(Icons.dashboard, color: Colors.white),
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
        inactiveIcons: const [
          Column(
            children: [
              Icon(Icons.dashboard, color: Colors.white),
              Text('Dashboard', style: TextStyle(color: Colors.white)),
            ],
          ),
          Column(
            children: [
              Icon(Icons.home, color: Colors.white),
              Text('Home', style: TextStyle(color: Colors.white)),
            ],
          ), 
          Column(
            children: [
              Icon(Icons.person, color: Colors.white),
              Text('Profile', style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
        color: const Color.fromARGB(255, 23, 35, 49), 
        height: 60,
        circleWidth: 60,
        activeIndex: tabIndex,
        onTap: (index) {
          tabIndex = index;
          pageController.jumpToPage(tabIndex);
        },
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        shadowColor: const Color.fromARGB(0, 243, 243, 243), 
        elevation: 10,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (v) {
          tabIndex = v;
        },
        children: [
          DashboardPage(),
          HomeContent(),
          ProfilePage(),
        ],
      ),
    );
  }
}
