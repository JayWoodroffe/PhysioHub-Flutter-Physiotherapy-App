import 'package:flutter/material.dart';

import '../models/Patient.dart';
import '../views/PatientDetailScreen.dart';

class ContactCard extends StatefulWidget {
  final Patient patient;
  final int unreadMessages;
  const ContactCard({required this.patient, required this.unreadMessages});

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientDetailScreen(patient: this.widget.patient),
          ),
        );
      },
      child:Card(
        color:  Color(0xFFF3F5F1),
        elevation: 2,
        margin: const EdgeInsets.all(6.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align elements at the ends
          children: [
            // Left: Profile image and name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.red,
                      child: CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(widget.patient.photoUrl),
                      ),
                    ),
                    // CircleAvatar(
                  //   radius: 30,
                  //   backgroundImage: NetworkImage(widget.patient.photoUrl), // Contact's image
                  // ),
                  SizedBox(width: 10),
                  // Contact name
                  Text(
                    widget.patient.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // Right: Notification bubble (if unread messages > 0)
            Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: widget.unreadMessages > 0
                    ? Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor, // Notification bubble color
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    '${widget.unreadMessages}', // Unread messages count
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ) : SizedBox.shrink()
            ),
          ],
        ),

      )

    );

  }
}
