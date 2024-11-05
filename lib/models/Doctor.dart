import 'Patient.dart';

class Doctor{ final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String profilePicture;
  List <Patient> patients; //list of all the patients linked to this doctor

  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    this.patients = const [], //default empty list
  });

  //converting the firebase data to model
  factory Doctor.fromMap(Map<String, dynamic> data,  String documentId) {
    return Doctor(
      id: documentId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'],
      profilePicture: data['profilePicture'] ?? '',
      patients: [], //initialises an empty list as this data isn't stored in the doctors firebase collection
    );
  }

  //converting model to firebase format
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
    };
  }
}