import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('MacroLens'),
          centerTitle: true,
          backgroundColor: Colors.blue[600],
        ),
        body: Center(
          child: Text(
            'Testing Auto Deployment',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue[600],
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ),
    ),
  );
}
