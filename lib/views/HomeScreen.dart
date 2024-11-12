import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/Appointment.dart';
import '../models/Doctor.dart';
import '../providers/DoctorProvider.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController notesController = TextEditingController();
  String notes = "";
  int selectedIndex = 0; //bottom navigation index
   Appointment? nextAppointment;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Future.microtask(() {
    //   Provider.of<DoctorProvider>(context, listen:false).fetchAppointmentsForDoctor();
    //
    //   final doctorProvider = Provider.of<DoctorProvider>(context);
    //   nextAppointment = doctorProvider.getNextAppointment()!;
    // });
  }

  void saveNotes() {
    notes = notesController.text;
  }

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

    // Access the logged-in Doctor from DoctorProvider
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final doctor = doctorProvider.doctor;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            _buildHeader(doctor),
            const SizedBox(height: 150.0),
            const Text(
              'your next appointment',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            FutureBuilder<void>(
              future: Provider.of<DoctorProvider>(context, listen: false).fetchAppointmentsForDoctor(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Display a loading indicator while waiting for data
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading appointments');
                } else {
                  final doctorProvider = Provider.of<DoctorProvider>(context);
                  final nextAppointment = doctorProvider.getNextAppointment();

                  return _buildAppointmentCard(nextAppointment);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Extracted Header Widget
  Widget _buildHeader(Doctor? doctor) {
    final doctor = Provider.of<DoctorProvider>(context).doctor;

    //current hour for time sensitive greeting
    int hour = DateTime.now().hour;

    String greeting;
    IconData icon;

    if (hour < 12){
      greeting = 'Good Morning';
      icon = Icons.wb_sunny;
    }
    else if(hour <17){
      greeting = 'Good Afternoon';
      icon = Icons.wb_cloudy;
    }else{
      greeting = 'Good Evening';
      icon = Icons.nights_stay;
    }


    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            SizedBox(height: 15),
            Text(greeting, style: TextStyle(fontSize: 20)),
            Text( 'Dr. ' + doctor!.name ?? '' ,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        const Spacer(), // Takes up the remaining space between text and icon
         Icon(
          icon,
          size: 80,
          color: Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  // Extracted Appointment Card Widget
  Widget _buildAppointmentCard(Appointment? nextAppointment) {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
        child: nextAppointment == null
            ? Text('No upcoming appointments')
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('d MMM, HH:mm').format(nextAppointment.dateTime),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // SizedBox(height: 8.0), // Adjusted spacing
            Text(
              nextAppointment.patientName,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),

    );
  }
}