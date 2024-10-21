import 'package:flutter/material.dart';
import 'package:physio_hub_flutter/views/MessagesScreen.dart';
import 'package:physio_hub_flutter/views/SettingsScreen.dart';
import 'package:physio_hub_flutter/views/AppointmentScreen.dart';
import 'package:physio_hub_flutter/views/HomeScreen.dart';
import 'package:physio_hub_flutter/views/LoginScreen.dart';

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
        theme: ThemeData(
          primaryColor:  Color(0xFF03738C),
          primarySwatch: Colors.indigo,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.red,
            selectedItemColor: Colors.indigo.shade600,
            unselectedItemColor: Colors.grey.shade600,
          ),
        ),
        initialRoute: '/home',
        routes: {
          '/home': (context) => const HomeScreen(),
          '/messages': (context) => const MessagesScreen(),
          '/appointments': (context) => const AppointmentScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
        home: LoginScreen()
        // Set the login screen as the initial screen
        );
  }
}


