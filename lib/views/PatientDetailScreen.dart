import 'package:flutter/material.dart';
import 'ChatScreen.dart';
import '../models/Patient.dart';
import 'ContactCardDetail.dart';
import 'ExerciseList.dart';

class PatientDetailScreen extends StatefulWidget {
  final Patient patient;

  PatientDetailScreen({required this.patient});

  @override
  _PatientDetailScreenState createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            // Navigate to a new screen or perform any action
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ContactCardDetail(patient: this.widget.patient)),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 20,
                // Size of the avatar
                backgroundImage: NetworkImage(widget.patient.photoUrl),
                // Use patient's image
                backgroundColor: Colors
                    .grey.shade200, // Fallback color if image is not loaded
              ),
              SizedBox(width: 10), // Spacing between avatar and text
              Text(widget.patient.name), // Display patient name
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).splashColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: Theme.of(context).primaryColor,
                // Change this to your desired indicator color
                labelColor: Theme.of(context).primaryColor,
                // Change this to your desired label color
                unselectedLabelColor: Colors.white,
                // Change this for unselected tab labels
                tabs: [
                  Tab(text: 'Messages'),
                  Tab(text: 'Exercises'),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ChatScreen(),
                  ExerciseList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
