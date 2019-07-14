import 'package:flutter/material.dart';
import 'package:flx/src/global_bloc.dart';
import 'package:flx/src/ui/main_menu/main_menu.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(FLX());
}

class FLX extends StatefulWidget {
  @override
  _FLXState createState() => _FLXState();
}

class _FLXState extends State<FLX> {
  GlobalBloc globalBloc;

  void initState() {
    globalBloc = GlobalBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<GlobalBloc>.value(
        value: globalBloc,
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            accentColor: Colors.deepPurpleAccent,
            fontFamily: 'Blad',
          ),
          home: MainMenu(),
          debugShowCheckedModeBanner: false,
        ));
  }
}
