import 'package:flutter/material.dart';
import 'package:physio_hub_flutter/widgets/bottom_navigation_bar.dart';
import 'package:physio_hub_flutter/widgets/exercise_card.dart';

import '../models/Exercise.dart';
import '../models/Patient.dart';
import '../widgets/contact_card.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  int selectedIndex = 1; //bottom navigation index



  //Test contact Data
  final List<Patient> patients = List.generate(
    10, // Create 10 exercise cards for testing
        (index) => Patient(
      'abc',
      'Gemma Erskine',
      'https://png.pngitem.com/pimgs/s/156-1568237_transparent-contact-icon-png-icon-for-create-user.png',
      26,
      '+36785673456',
      'ABC',
      'presents with a history of chronic lower back pain, primarily attributed \n'
          'to prolonged sitting at work. He has undergone three months of rehabilitation \n'
          'focused on core strengthening and posture correction, with moderate \n'
          'improvement noted in his mobility and pain levels. Continue to monitor for any \n'
          'recurrence of pain, and consider integrating more dynamic stretching exercises into his routine to enhance flexibility and reduce the risk of future injuries'
    ),
  );

  //navigating using the bottom navigation
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 20.0),
              child: Row(
                children: [
                  Icon(Icons.people_alt,size: 50, color: Theme.of(context).primaryColor,),
                  SizedBox(width: 15.0,),
                  Text('Patients',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            //list of patients
            Expanded(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 2.0,
                    childAspectRatio: 4.5,
                  ),
                  itemCount: patients.length,
                  itemBuilder: (context, index){
                    return ContactCard(patient: patients[index], unreadMessages: 3,);
                  }),
            ),
          ],
        ),
      ),

    );
  }
}
