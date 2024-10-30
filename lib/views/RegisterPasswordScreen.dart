import 'package:flutter/material.dart';

import '../controllers/DoctorController.dart';
import '../models/Doctor.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';

class RegisterPasswordScreen extends StatefulWidget {
  //information from the previous register screen
  final String name;
  final String email;
  final String phoneNumber;

  const RegisterPasswordScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  @override
  State<RegisterPasswordScreen> createState() => _RegisterPasswordScreenState();
}

class _RegisterPasswordScreenState extends State<RegisterPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  //controller to manage the doctor's info in the db
  final DoctorController _doctorController = DoctorController();


  // Controllers for text fields
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Function to handle form submission
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {

      Doctor doctor = Doctor(
        id: '', // Temporary, will be set by Firestore
        name: widget.name,
        email: widget.email,
        phoneNumber: widget.phoneNumber,
        profilePicture: '', // Profile picture will be added later
      );

      // Register the doctor
      String? errorMessage = await _doctorController.registerDoctor(
          doctor,
        _passwordController.text,
      );

      if (errorMessage == null) {
        // Registration was successful, navigate to the home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
        );
      } else {
        // Show error message if registration failed
        print(errorMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            SizedBox(height: 40),
            Text(
              'Create a Password',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 40),

            // Password TextField
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
              ),
              obscureText: true, // Obscure text for password
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),

            // Confirm Password TextField
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirm Password',
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
              ),
              obscureText: true, // Obscure text for password
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),

            // Register Button
            FilledButton(
              onPressed: _submitForm,
              child: Text('Create Password', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}