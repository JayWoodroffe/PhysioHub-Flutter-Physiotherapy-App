import 'package:flutter/material.dart';

import 'LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  //controllers for text fields
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Variable to hold checkbox state
  bool _isLicensed = false;

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Function to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_isLicensed) {
        //TODO process registration logic here - add user
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Registration TODO!'),
          backgroundColor: Theme.of(context).splashColor,
        ));
      } else {
        // Show error if checkbox is not checked
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('You must confirm you are a licensed physiotherapist.'),
          backgroundColor: Colors.red,
        ));
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
          SizedBox(
            height: 40,
          ),
          Text(
            'Create an account',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).primaryColor),
          ),
          SizedBox(
            height: 40,
          ),
          //name field
          TextFormField(
            controller: _fullNameController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Full Name',
                labelStyle: TextStyle(color: Theme.of(context).primaryColor)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),
          //email field
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email Address',
                labelStyle: TextStyle(color: Theme.of(context).primaryColor)),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email address';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),

          // Phone Number TextField
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Phone Number',
                labelStyle: TextStyle(color: Theme.of(context).primaryColor)),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                return 'Please enter a valid 10-digit phone number';
              }
              return null;
            },
          ),

          SizedBox(height: 16.0),

          // Checkbox for licensed physiotherapist
          CheckboxListTile(
            title: Text('I am a licensed physiotherapist'),
            value: _isLicensed,
            activeColor: Theme.of(context).splashColor,
            onChanged: (bool? value) {
              setState(() {
                _isLicensed = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return LoginScreen();
                  }));
            },
            child: Text('Register', style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
          ),
        ]),
      ),
    ));
  }
}
