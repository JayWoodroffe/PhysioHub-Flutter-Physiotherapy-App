import 'package:flutter/material.dart';
import 'package:physio_hub_flutter/controllers/PatientController.dart';
import '../models/Doctor.dart';
import '../controllers/DoctorController.dart';
import '../models/Patient.dart';

class DoctorProvider with ChangeNotifier {
  final DoctorController _doctorController = DoctorController();
  final PatientController _patientController = PatientController();

  Doctor? _doctor;
  Doctor? get doctor => _doctor;

  Future<String?> loginDoctor(String email, String password) async {
    String? result = await _doctorController.loginDoctor(email, password);
    if (result == null) {
      // If login is successful, set the current doctor and notify listeners
      _doctor = _doctorController.currentDoctor;
      notifyListeners();
    }
    return result;

  }
  //to retrieve the patients of the logged in doctor
  Future<void> fetchPatientsForDoctor() async{
    //if the doctor is null or the patient list has already been filled
    if (_doctor == null|| (_doctor?.patients.isNotEmpty ?? false)) return;

    List<Patient> patients = await _patientController.getPatientsForDoctor(_doctor!.id);

    // Update the logged-in doctor with the retrieved patients
    _doctor = Doctor(
      id: _doctor!.id,
      name: _doctor!.name,
      email: _doctor!.email,
      phoneNumber: _doctor!.phoneNumber,
      profilePicture: _doctor!.profilePicture,
      patients: patients, // Update patients
    );
    notifyListeners(); //to update the UI
  }
}
