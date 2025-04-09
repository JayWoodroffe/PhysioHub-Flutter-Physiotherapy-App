import 'package:flutter_test/flutter_test.dart';
import 'package:physio_hub_flutter/models/Doctor.dart';

void main() {
  group('Doctor Model Tests', () {
    test('Doctor fromMap creates a Doctor object correctly', () {
      final doctorData = {
        'name': 'Dr. Smith',
        'email': 'dr.smith@example.com',
        'phoneNumber': '1234567890',
        'profilePicture': 'http://example.com/profile.jpg',
      };

      final doctor = Doctor.fromMap(doctorData, 'docId');

      expect(doctor.name, 'Dr. Smith');
      expect(doctor.email, 'dr.smith@example.com');
      expect(doctor.phoneNumber, '1234567890');
      expect(doctor.profilePicture, 'http://example.com/profile.jpg');
    });
  });
}