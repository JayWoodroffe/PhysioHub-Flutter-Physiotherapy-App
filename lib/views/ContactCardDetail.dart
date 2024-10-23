import 'package:flutter/material.dart';

import '../models/Patient.dart';

class ContactCardDetail extends StatelessWidget {
  final Patient patient;

  const ContactCardDetail({required this.patient, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.patient.name, style: TextStyle(fontSize: 25),),
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 60),
          CircleAvatar(
            radius: 70,
            // Size of the avatar
            backgroundImage: NetworkImage(this.patient.photoUrl),
            // Use patient's image
            backgroundColor:
                Colors.grey.shade200, // Fallback color if image is not loaded
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                this.patient.phoneNumber,
                style: TextStyle(fontSize: 25),
              ),
              Icon(Icons.phone,
              size: 20,)
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Align(
              alignment: Alignment.centerLeft, // Align left
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align text to the left
                children: [
                  Text(
                    'Age: ${this.patient.age}',
                    // Assuming you have an age property
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8), // Space between age and notes
                  Text(
                    'Notes:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4), // Space between notes label and content
                  Text(
                    this.patient.notes, // Assuming you have a notes property
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.left, // Ensure text is left-aligned
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
