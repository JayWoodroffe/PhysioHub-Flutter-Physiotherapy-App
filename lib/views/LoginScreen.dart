import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/DoctorProvider.dart';
import 'HomeScreen.dart';
import 'RegisterScreen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Expanded(child: SingleChildScrollView(
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
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        labelStyle:
                        TextStyle(color: Theme.of(context).primaryColor))),
                SizedBox(height: 10),
                TextField(
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
                      String? result = await Provider.of<DoctorProvider>(context, listen: false).loginDoctor(email, password);

                      if (result == null) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
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
        ))
      ),
    );
  }
}
