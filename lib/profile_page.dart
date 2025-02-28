import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String firstName = '';
  String lastName = '';
  int weight = 0;
  int goalWeight = 0;
  int caloriesGoal = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        firstName = userDoc['firstName'];
        lastName = userDoc['lastName'];
        weight = userDoc['weight'];
        goalWeight = userDoc['goalWeight'];
        caloriesGoal = userDoc['caloriesGoal'];
      });
    }
  }

  Future<void> _saveCaloriesGoal() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'caloriesGoal': caloriesGoal,
      });
    }
  }

  void _calculateCaloriesGoal() {
    setState(() {
      if (goalWeight > weight) {
        caloriesGoal = (2000 + (goalWeight - weight) * 10).toInt();
      } else {
        caloriesGoal = (2000 - (weight - goalWeight) * 10).toInt();
      }
      _saveCaloriesGoal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/profile_blank.jpg'),
              ),
              SizedBox(height: 20),
              Text(
                'First Name: $firstName',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Last Name: $lastName',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(labelText: 'Current Weight (kg)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  weight = int.parse(value);
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Goal Weight (kg)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  goalWeight = int.parse(value);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateCaloriesGoal,
                child: Text('Set Calories Goal'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Calories Goal: $caloriesGoal',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text('Log Out'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
