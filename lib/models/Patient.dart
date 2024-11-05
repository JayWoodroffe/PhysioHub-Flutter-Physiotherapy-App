import 'package:cloud_firestore/cloud_firestore.dart';

class Patient{
  final String id;
  final String name;
  final String photoUrl;
  final DateTime dob;
  final String phoneNumber;
  final String email;
  final String doctorId;
  String notes;

  Patient(this.id, this.name, this.photoUrl, this.dob, this.phoneNumber, this.email, this.doctorId, this.notes);

  // Method to convert a Patient to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'photoUrl': photoUrl,
      'dob': dob,
      'phoneNumber': phoneNumber,
      'email': email,
      'doctorId': doctorId,
      'notes': notes,
    };
  }

  // Factory method to create a Patient from Firestore data
  factory Patient.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Patient(
      doc.id,
      data['name'] ?? '',
      data['photoUrl'] ?? '',
      (data['dob'] as Timestamp?)?.toDate() ?? DateTime(1970, 1, 1), // Convert Timestamp to DateTime
      data['phoneNumber'] ?? '',
      data['email'] ?? '', // Retrieve email
      data['doctorId'] ?? '',
      data['notes'] ?? '',
    );
  }

  int calculateAge(){
    final DateTime today = DateTime.now();
    int age = today.year - dob.year;

    if (today.month < dob.month || (today.month == dob.month && today.day < dob.day)){
      age--;
    }
    return age;
  }

}