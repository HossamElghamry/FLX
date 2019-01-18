import 'package:flutter/material.dart';
import './flx.dart';

import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

void main() async{
  await googleSignIn.signIn();
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

