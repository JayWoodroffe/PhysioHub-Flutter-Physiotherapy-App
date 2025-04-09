import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/DoctorProvider.dart';
import 'HomeScreen.dart';
import 'RegisterScreen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to show alert dialog with a message
  void _showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Login Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Image.asset(
                  'assets/images/logo.png',
                  width: 200,
                ),
                SizedBox(height: 20),
                Text('PhysioHub',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    )),
                SizedBox(height: 40),
                TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        labelStyle:
                        TextStyle(color: Theme.of(context).primaryColor))),
                SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      labelStyle:
                      TextStyle(color: Theme.of(context).primaryColor)),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: () async {
                      String email = _emailController.text.trim();
                      String password = _passwordController.text.trim();

                      print (email + ' ' + password);

                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter both email and password.")),
                        );
                        return;
                      }
                      //login process
                      String? result = await Provider.of<DoctorProvider>(context, listen: false).loginDoctor(email, password);

                      if (result == null) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                      } else {
                        // Customize the error message based on the result
                        String errorMessage;
                        if (result.contains("Doctor data")) {
                          errorMessage = "Physiotherapist details not found. If you're a patient, please use the PhysioLink app.";
                        } else if (result.contains("invalid login details") || result.contains("malformed")) {
                          errorMessage = "Incorrect login details. Please check your email and password.";
                        } else {
                          errorMessage = result; // Fallback to the default error message
                        }
                        _showAlertDialog(context, errorMessage); // Show the error message
                        print(result);
                      }
                    },
                    child: Text('Login', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),
                SizedBox(height: 40),

                Text(
                  'Don\'t have an account?',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                            return RegisterScreen();
                          }));
                    },
                    child: Text(
                      'Create an account',
                      style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor),
                    )),
                SizedBox(height: 40)
              ],
            ),
          ),
        ),
      ),
    );
  }
}