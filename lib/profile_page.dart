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
  String sex = 'male';
  int height = 0;
  int age = 0;
  String activityLevel = 'Moderate';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'firstName': firstName,
          'lastName': lastName,
          'weight': weight,
          'goalWeight': goalWeight,
          'caloriesGoal': caloriesGoal,
          'sex': sex,
          'height': height,
          'age': age,
          'activityLevel': activityLevel,
        });
        userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      }
      setState(() {
        firstName = userDoc['firstName'];
        lastName = userDoc['lastName'];
        weight = userDoc['weight'];
        goalWeight = userDoc['goalWeight'];
        caloriesGoal = userDoc['caloriesGoal'];
        sex = userDoc['sex'] ?? 'male';
        height = userDoc['height'] ?? 170;
        age = userDoc['age'] ?? 25;
        activityLevel = userDoc['activityLevel'] ?? 'Moderate';
      });
    }
  }

  Future<void> _saveUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'firstName': firstName,
        'lastName': lastName,
        'weight': weight,
        'goalWeight': goalWeight,
        'caloriesGoal': caloriesGoal,
        'sex': sex,
        'height': height,
        'age': age,
        'activityLevel': activityLevel,
      });
    }
  }

  double _calculateBMR() {
    if (sex == 'male') {
      return (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      return (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }
  }

  double _getActivityMultiplier() {
    switch (activityLevel) {
      case 'Sedentary':
        return 1.2;
      case 'Light':
        return 1.375;
      case 'Moderate':
        return 1.55;
      case 'Active':
        return 1.725;
      case 'Super Active':
        return 1.9;
      default:
        return 1.55;
    }
  }

  void _calculateCaloriesGoal() {
    double bmr = _calculateBMR();
    double tdee = bmr * _getActivityMultiplier();

    setState(() {
      if (goalWeight > weight) {
        caloriesGoal = (tdee + 500).toInt(); 
      } else {
        caloriesGoal = (tdee - 500).toInt(); 
      }
      _saveUserData();
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
              Text('First Name: $firstName', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Last Name: $lastName', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(labelText: 'Current Weight (kg)'),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: weight.toString()),
                onChanged: (value) {
                  weight = int.parse(value);
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Goal Weight (kg)'),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: goalWeight.toString()),
                onChanged: (value) {
                  goalWeight = int.parse(value);
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: height.toString()),
                onChanged: (value) {
                  height = int.parse(value);
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: age.toString()),
                onChanged: (value) {
                  age = int.parse(value);
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: sex,
                decoration: InputDecoration(
                  labelText: 'Sex',
                  border: OutlineInputBorder(),
                ),
                dropdownColor: const Color.fromARGB(255, 23, 35, 49),
                style: TextStyle(color: Colors.white),
                items: ['male', 'female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.capitalize()),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    sex = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: activityLevel,
                decoration: InputDecoration(
                  labelText: 'Activity Level',
                  border: OutlineInputBorder(),
                ),
               dropdownColor: const Color.fromARGB(255, 23, 35, 49),
                style: TextStyle(color: Colors.white),
                items: ['Sedentary', 'Light', 'Moderate', 'Active', 'Super Active'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    activityLevel = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateCaloriesGoal,
                child: Text('Set Calories Goal'),
              ),
              SizedBox(height: 20),
              Text('Calories Goal: $caloriesGoal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text('Log Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}
