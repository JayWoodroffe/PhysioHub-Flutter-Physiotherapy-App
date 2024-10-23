import 'package:flutter/material.dart';
import 'package:physio_hub_flutter/widgets/bottom_navigation_bar.dart';
import 'package:physio_hub_flutter/widgets/exercise_card.dart';

import '../models/Exercise.dart';
import '../models/Patient.dart';
import '../widgets/contact_card.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  int selectedIndex = 1; //bottom navigation index

  // Test exercise data
  final List<Exercise> exercises = List.generate(
    10, // Create 10 exercise cards for testing
        (index) => Exercise(
      'Push Up',
      'Chest',
      'https://v2.exercisedb.io/image/QDMc9VZ35SCc7T', // Replace with actual GIF URLs
    ),
  );

  //Test contact Data
  final List<Patient> patients = List.generate(
    10, // Create 10 exercise cards for testing
        (index) => Patient(
      'abc',
      'Gemma Erskine',
      'https://png.pngitem.com/pimgs/s/156-1568237_transparent-contact-icon-png-icon-for-create-user.png',
      23, 
      '00000000000',
      'ABC'
    ),
  );

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/messages');
        break;
      case 2:
        Navigator.pushNamed(context, '/appointments');
        break;
      case 3:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: selectedIndex,
          onItemTapped: onItemTapped
      ),
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 2.0,
            childAspectRatio: 5,
          ),
          itemCount: patients.length,
          itemBuilder: (context, index){
            return ContactCard(patient: patients[index], unreadMessages: 3,);
          }),
    );
  }
}
