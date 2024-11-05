import 'package:flutter/material.dart';
import 'package:physio_hub_flutter/widgets/bottom_navigation_bar.dart';
import 'package:physio_hub_flutter/widgets/exercise_card.dart';
import 'package:provider/provider.dart';

import '../models/Exercise.dart';
import '../models/Patient.dart';
import '../providers/DoctorProvider.dart';
import '../widgets/contact_card.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  int selectedIndex = 1; //bottom navigation index

  @override
  void initState(){
    super.initState();

    //fetching patients when the screen loads
    Future.microtask((){
      Provider.of<DoctorProvider>(context, listen:false).fetchPatientsForDoctor();

    });
  }


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
              child: Consumer<DoctorProvider>(
                builder: (context, doctorProvider, _) {
                  final patients = doctorProvider.doctor?.patients ?? []; //get patients list

                  //check if list is empty
                  if (patients.isEmpty){
                    return Center(
                      child: Text(
                        'No patients available',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }
                  return  GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 2.0,
                        mainAxisSpacing: 2.0,
                        childAspectRatio: 4.5,
                      ),
                      itemCount: patients.length,
                      itemBuilder: (context, index){
                        return ContactCard(patient: patients[index], unreadMessages: 3,);
                      },
                    //TODO calculate the number of unread messages
                  );
                },
              ),
            ),
          ],
        ),
      ),

    );
  }
}
