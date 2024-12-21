import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/storage/v1.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:image_picker/image_picker.dart';
import 'package:physio_hub_flutter/controllers/AppointmentController.dart';
import 'package:physio_hub_flutter/controllers/PatientController.dart';
import '../controllers/ChatMessageController.dart';
import '../models/Appointment.dart';
import '../models/Doctor.dart';
import '../controllers/DoctorController.dart';
import '../models/Patient.dart';
import 'package:path/path.dart' as path;

class DoctorProvider with ChangeNotifier {
  final DoctorController _doctorController = DoctorController();
  final PatientController _patientController = PatientController();
  final AppointmentController _appointmentController = AppointmentController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Doctor? _doctor;
  Doctor? get doctor => _doctor;

  final ImagePicker _picker = ImagePicker();
  StorageApi? _storageApi = null;

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

  //method to update the profile photo
  Future<String?> updateProfilePicture() async{
    try {
      await _initialiseGoogleStorage();

      // Select an image using ImagePicker
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return "No image selected.";

      // Convert to File and get file name
      File file = File(pickedFile.path);
      String fileName = path.basename(pickedFile.path);

      // Define the media upload
      var media = Media(file.openRead(), file.lengthSync(), contentType: "image/jpeg");
      var object = Object(name: fileName);

      // Perform the upload
      var result = await _storageApi!.objects.insert(object, 'physio_profile_pictures', uploadMedia: media);

      // Construct the public URL for the uploaded image
      String imageUrl = 'https://storage.googleapis.com/physio_profile_pictures/$fileName';
      _doctorController.uploadProfilePicture(_doctor!.id, imageUrl);
      _doctor!.profilePicture = imageUrl;
      notifyListeners();
      return imageUrl; // Return URL to be stored in Firestore or elsewhere
    } catch (e) {
      print('$e');
      return 'Error uploading image: $e';
    }
  }

  void updateDoctorName(String newName) {
    if (doctor != null) {
      doctor!.name = newName;
      _doctorController.updateName(_doctor!.id, newName);
      notifyListeners(); // Notify listeners to rebuild UI
    }
  }

  Future <void> _initialiseGoogleStorage() async{
    if(_storageApi != null) return; //already initialised

    //load the service account credentials
    final credentialsJson = await rootBundle.loadString('assets/credentials.json');
    final credentials = ServiceAccountCredentials.fromJson(jsonDecode(credentialsJson));
    final client = await clientViaServiceAccount(credentials, [StorageApi.devstorageFullControlScope]);

    _storageApi = StorageApi(client);
  }

  // Method to load doctor data using the user object
  Future<String?> loadDoctorDataFromUID(User user) async {
    String? result = await _doctorController.loadDoctorDataById(user.uid);
    if (result == null) {
      // If login is successful, set the current doctor and notify listeners
      _doctor = _doctorController.currentDoctor;
      notifyListeners();
    }
    return result;
  }

  //logging out
  Future<String?> logoutDoctor() async {
    try {
      await _auth.signOut();
      return null;  // Return null if logout is successful
    } catch (e) {
      return 'An error occurred while logging out.';  // Return error message if something fails
    }
  }

  // Setup real-time listeners for unread messages for each patient
  void fetchUnreadMessageCounts() {
    if (doctor != null && doctor!.patients.isNotEmpty) {
      for (Patient patient in doctor!.patients) {
        final controller = ChatMessageController(
          doctorId: doctor!.id!,
          patientId: patient.id,
        );
        // Listen to unread message count stream for each patient
        controller.getUnreadMessageCountStream().listen((unreadCount) {
          patient.unreadMessages = unreadCount;
          notifyListeners(); // Update UI when count changes
        });
      }
    }
  }

}
