import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:physio_hub_flutter/controllers/InvitationController.dart';
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
  final InvitationController _invitationController = InvitationController();
  int selectedIndex = 1; //bottom navigation index

  @override
  void initState() {
    super.initState();

    //fetching patients when the screen loads
    Future.microtask(() {
      Provider.of<DoctorProvider>(context, listen: false)
          .fetchPatientsForDoctor();
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

  _addPatient(String doctorId) async {
    //creating the invitation code
    String? code = await _invitationController.createInvitation(doctorId);

    //display the generated code
    if (code != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('New Invitation Code'),
            content: SingleChildScrollView(
              // Wrap Column in SingleChildScrollView
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          code,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy,
                            color: Theme.of(context).primaryColor),
                        onPressed: () {
                          //copy the code to clipboard
                          Clipboard.setData(ClipboardData(text: code));
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(content: Text('Code copied to clipboard')),
                          // );
                        },
                      ),
                    ],
                  ),
                  Text(
                    'Send this code to your new patient. When they register, they will be prompted to '
                    'provide this code, which will link them as your patient.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      // Handle case when code generation fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to generate an invitation code.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final doctorId = doctorProvider.doctor?.id;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addPatient(doctorId!),
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: selectedIndex, onItemTapped: onItemTapped),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 20.0),
              child: Row(
                children: [
                  Icon(
                    Icons.people_alt,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text('Patients',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            //list of patients
            Expanded(
              child: Consumer<DoctorProvider>(
                builder: (context, doctorProvider, _) {
                  final patients =
                      doctorProvider.doctor?.patients ?? []; //get patients list

                  //check if list is empty
                  if (patients.isEmpty) {
                    return Center(
                      child: Text(
                        'No patients available',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0,
                      childAspectRatio: 4.5,
                    ),
                    itemCount: patients.length,
                    itemBuilder: (context, index) {
                      return ContactCard(
                        patient: patients[index],
                        unreadMessages: 3,
                      );
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
