import 'package:cloud_firestore/cloud_firestore.dart';

class Patient{
  final String id;
  final String name;
  final String photoUrl;
  final int age;
  final String phoneNumber;
  final String doctorId;
  String notes;
  Patient(this.id, this.name, this.photoUrl, this.age, this.phoneNumber, this.doctorId, this.notes);

  // Method to convert a Patient to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'photoUrl': photoUrl,
      'age': age,
      'phoneNumber': phoneNumber,
      'doctorId': doctorId,
      'notes': notes,
    };
  }

  // Factory method to create a Patient from Firestore data
  factory Patient.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Patient(
      doc.id, // Use Firestore document ID as the Patient ID
      data['name'] ?? '',
      data['photoUrl'] ?? '',
      data['age'] ?? 0,
      data['phoneNumber'] ?? '',
      data['doctorId'] ?? '',
      data['notes'] ?? '',
    );
  }
}