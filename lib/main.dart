import 'package:flutter/material.dart';
import 'package:physio_hub_flutter/views/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        // title: 'PhysioHub',
        // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        // ),
        home: LoginScreen()
        // Set the login screen as the initial screen
        );
  }
}


