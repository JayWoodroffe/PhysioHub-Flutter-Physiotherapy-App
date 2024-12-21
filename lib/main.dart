import 'package:flutter/material.dart';
import 'package:physio_hub_flutter/providers/DoctorProvider.dart';
import 'package:physio_hub_flutter/providers/ExerciseProvider.dart';
import 'package:physio_hub_flutter/views/PatientListScreen.dart';
import 'package:physio_hub_flutter/views/SettingsScreen.dart';
import 'package:physio_hub_flutter/views/AppointmentScreen.dart';
import 'package:physio_hub_flutter/views/HomeScreen.dart';
import 'package:physio_hub_flutter/views/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider<ExerciseProvider>(create: (_) => ExerciseProvider()),
      ],
      child: MyApp(),
    ),
  );
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
          splashColor:  Colors.green.shade200,
          // TextField and TextFormField style settings
          inputDecorationTheme: InputDecorationTheme(
            // Focused border (when field is active)
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.green.shade200,  // Set focused border to primary color
                width: 2.0,  // You can adjust the width of the border
              ),
              borderRadius: BorderRadius.circular(5.0),  // Optional: Add rounded corners
            ),
            // Default border style when not focused
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color:  Color(0xFF03738C),  // Default border when not focused
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          // Cursor color globally for all text input fields
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: const Color(0xFF03738C),  // Cursor color matches primary color
            selectionColor: Colors.green.shade200,  // Text selection color matches splash
            selectionHandleColor: Color(0xFF03738C),  // Handle color when text is selected
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: Color(0xFF03738C),
            unselectedItemColor: Colors.grey.shade600,
          ),
        ),
      initialRoute: '/', // Start with AuthCheck to verify user state
      routes: {
        '/': (context) => AuthCheck(), // Auth check route
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/messages': (context) => PatientListScreen(),
        '/appointments': (context) => AppointmentScreen(),
        '/settings': (context) => SettingsScreen(),
      },
        // Set the login screen as the initial screen
        );
  }
}


class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool _isUserChecked = false; // To track if auth state has been checked

  @override
  void initState() {
    super.initState();
    // Listen for auth state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      setState(() {
        _isUserChecked =
        true; // Set the check flag to true once the auth state is known
      });

      if (user != null) {
        // If user is signed in, navigate to the home screen
        await Provider.of<DoctorProvider>(context, listen: false)
            .loadDoctorDataFromUID(user);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // If user is not signed in, navigate to the login screen
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isUserChecked
          ? Container() // Once the auth state is checked, show an empty container
          : Center(
          child: CircularProgressIndicator()), // Show a loading spinner while checking auth state
    );
  }
}


