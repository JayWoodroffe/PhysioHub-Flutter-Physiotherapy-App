import 'package:flutter/material.dart';
import 'package:physio_hub_flutter/controllers/AppointmentController.dart';
import 'package:physio_hub_flutter/controllers/PatientController.dart';
import '../models/Appointment.dart';
import '../models/Doctor.dart';
import '../controllers/DoctorController.dart';
import '../models/Patient.dart';

class DoctorProvider with ChangeNotifier {
  final DoctorController _doctorController = DoctorController();
  final PatientController _patientController = PatientController();
  final AppointmentController _appointmentController = AppointmentController();

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

  //to retrieve appointments for the logged in doctor
  Future<void> fetchAppointmentsForDoctor() async{
    if (_doctor == null||(_doctor?.appointments.isNotEmpty ?? false)) return;

    List<Appointment> appointments = await _appointmentController.getAppointments(_doctor!.id);

    //update logged in doctor
    _doctor = Doctor(
      id: _doctor!.id,
      name: _doctor!.name,
      email: _doctor!.email,
      phoneNumber: _doctor!.phoneNumber,
      profilePicture: _doctor!.profilePicture,
      patients: _doctor!.patients, // Update patients
      appointments: appointments,
    );
    notifyListeners(); //to update the UI
  }

  //method to get the next appointment for the doctor
  Appointment? getNextAppointment(){
    if (_doctor == null || (_doctor!.appointments.isEmpty))return null;

    //get current date and time
    DateTime now = DateTime.now();

    //find the next appointment
    List<Appointment> upcomingAppointments = _doctor!.appointments.where((appointment) =>
      appointment.dateTime.isAfter(now)).toList();
    upcomingAppointments.sort((a, b) => a.dateTime.compareTo(b.dateTime));//sort by date
    return upcomingAppointments.isNotEmpty? upcomingAppointments.first: null;
  }
}
