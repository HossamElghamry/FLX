import 'package:flutter/material.dart';
import 'package:flx/src/ui/main_menu/main_menu.dart';

void main() {
  runApp(FLX());
}

class FLX extends StatefulWidget {
  @override
  _FLXState createState() => _FLXState();
}

class _FLXState extends State<FLX> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
        fontFamily: 'Blad',
      ),
      home: MainMenu(),
      debugShowCheckedModeBanner: false,
    );
  }
}
