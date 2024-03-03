import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onlinegrocerystore/screens/landing_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "App",
      theme: ThemeData(
        primaryColor: const Color(0xff1faa00),
        accentColor: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: LandingPage(),
    );
  }
}
