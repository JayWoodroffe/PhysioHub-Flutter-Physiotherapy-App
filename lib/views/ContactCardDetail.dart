import 'package:flutter/material.dart';
import 'package:physio_hub_flutter/controllers/PatientController.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/Patient.dart';

class ContactCardDetail extends StatefulWidget {
  final Patient patient;

  const ContactCardDetail({required this.patient, Key? key}) : super(key: key);

  @override
  State<ContactCardDetail> createState() => _ContactCardDetailState();
}

class _ContactCardDetailState extends State<ContactCardDetail> {
  late TextEditingController _notesController;
  final PatientController _patientController = PatientController();



  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.patient.notes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }


  void _editNotes() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit notes'),
            content: SingleChildScrollView(
              child: Column(children: <Widget>[
                TextField(
                  controller: _notesController,
                  maxLines: 15,
                  decoration: InputDecoration(
                    labelText: this.widget.patient.name,
                    labelStyle:
                        TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ]),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                  onPressed: () async {
                    // Attempt to update the patient's notes
                    String message = await _patientController.updatePatientNotes(
                      widget.patient.id, // Use the patient ID
                      _notesController.text,
                    );

                    // Update the local state
                    setState(() {
                      widget.patient.notes = _notesController.text; // Update the patient notes
                    });

                    // Show Snackbar with the result message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    // Close the dialog after updating
                    Navigator.of(context).pop();
                  },
                  child: Text('Save'))
            ],
          );
        });
  }

  //method to launch the phone dialer with the patient's number
  void _callPatient() async{
    final Uri phoneUri = Uri(scheme: 'tel', path: widget.patient.phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not launch phone dialer")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          this.widget.patient.name,
          style: TextStyle(fontSize: 25),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 60),
          CircleAvatar(
            radius: 70,
            // Size of the avatar
            backgroundImage: NetworkImage(this.widget.patient.photoUrl),
            // Use patient's image
            backgroundColor:
                Colors.grey.shade200, // Fallback color if image is not loaded
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                this.widget.patient.phoneNumber + '\t\t\t',
                style: TextStyle(fontSize: 25),
              ),
              GestureDetector(
                onTap: _callPatient,
                child: Icon(
                  Icons.phone,
                  size: 25,
                  color:Theme.of(context).primaryColor ,
                ),
              )
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
                    'Age: ${this.widget.patient.calculateAge()}',
                    // Assuming you have an age property
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  // Space between age and notes
                  Row(
                    children: [
                      Text(
                        'Notes:',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                      Spacer(),
                      GestureDetector(
                          onTap: _editNotes,
                          child: Icon(
                            Icons.edit,
                            color: Theme.of(context).primaryColor,
                            size: 25,
                          ))
                    ],
                  ),
                  SizedBox(height: 4),
                  // Space between notes label and content
                  Text(
                    this.widget.patient.notes,
                    // Assuming you have a notes property
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
