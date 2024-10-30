import 'package:flutter/material.dart';
import '../models/Doctor.dart';
import '../controllers/DoctorController.dart';

class DoctorProvider with ChangeNotifier {
  final DoctorController _doctorController = DoctorController();

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
}
