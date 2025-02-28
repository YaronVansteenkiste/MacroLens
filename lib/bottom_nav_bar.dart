import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';

Widget buildBottomNavBar(int tabIndex, PageController pageController, {required Function(int) onTabChanged}) {
  return CircleNavBar(
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
      onTabChanged(index); 
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
  );
}