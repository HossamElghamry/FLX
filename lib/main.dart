import 'package:flutter/material.dart';
import './flx.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "FLEX: Test your Reflex",
    theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
        fontFamily: 'Blad'
      ),
    home: Flx(),
  ));

}

