import 'package:flutter/material.dart';
import 'package:macro_lens/add_meal_page.dart';
import 'package:macro_lens/home_content.dart';
import 'package:macro_lens/profile_page.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 21, 27, 35),
      ),
      body: PersistentTabView(
        tabs: [
          PersistentTabConfig(
            screen: yourFirstScreen(),
            item: ItemConfig(
              icon: Icon(Icons.home),
              title: "Home",
            ),
          ),
          PersistentTabConfig(
            screen: yourSecondScreen(),
            item: ItemConfig(
                icon: Icon(Icons.add),
                inactiveForegroundColor: Colors.white,
                activeColorSecondary: Colors.white,
            ),
          ),
          PersistentTabConfig(
            screen: yourThirdScreen(),
            item: ItemConfig(
                icon: Icon(Icons.person),
                title: "Profile",
            ),
          ),
        ],
        navBarBuilder: (navBarConfig) => Style13BottomNavBar(
          navBarConfig: navBarConfig,
          navBarDecoration: NavBarDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: const Color.fromARGB(255, 23, 35, 49),
          ),
        ),
      ),
    );
  }
}

Widget yourFirstScreen() {
  return HomeContent();
}

Widget yourSecondScreen() {
  return AddMealPage();
}

Widget yourThirdScreen() {
  return ProfilePage();
}