import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment{
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime dateTime;
  final String patientName;
  const Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.dateTime,
    required this.patientName});


  // Factory method to create an Appointment from Firestore data
  factory Appointment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Appointment(
      id: doc.id, // Use Firestore document ID as the Appointment ID
      patientId: data['patientId'] ?? '', // Use null-aware operator to handle missing data
      doctorId: data['doctorId'] ?? '',
      dateTime: (data['dateTime'] as Timestamp).toDate(), // Convert Firestore Timestamp to DateTime
      patientName: data['patientName'] ?? ''
    );
  }

  // Method to convert an Appointment to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'dateTime': Timestamp.fromDate(dateTime), // Convert DateTime to Firestore Timestamp
      'patientName': patientName
    };
  }
}