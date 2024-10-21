import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController notesController = TextEditingController();
  String notes = "";

  void saveNotes() {
    notes = notesController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        fixedColor:Color(0xFF03738C),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            backgroundColor:const Color(0xFFEAEAEA) ,
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_rounded),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          )
        ],
      ),
    body: Container(
    width: double.infinity,
    height: double.infinity,
    color: const Color(0xFFEAEAEA),
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const SizedBox(height: 20.0),
    _buildHeader(),
    const SizedBox(height: 150.0),
    const Text(
    'your next appointment',
    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 16.0),
    _buildAppointmentCard(),
    ],
    ),
    )
    ,

    );
  }

  // Extracted Header Widget
  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 15),
            Text('Good Morning', style: TextStyle(fontSize: 20)),
            Text('Dr. Jay Woodroffe',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        const Spacer(), // Takes up the remaining space between text and icon
        const Icon(
          Icons.sunny,
          size: 80,
          color: Color(0xFF03738C),
        ),
      ],
    );
  }

  // Extracted Appointment Card Widget
  Widget _buildAppointmentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF03738C),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '17 Oct 6:41 pm',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.0), // Adjusted spacing
          Text(
            'Gemma Erskine',
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