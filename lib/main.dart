import 'package:flutter/material.dart';
import './flx.dart';

void main() {
  runApp(MaterialApp(
    title: "FLEX: Test your Reflex",
    theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent
      ),
    home: Flx(),
  ));

}

