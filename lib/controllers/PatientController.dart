import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:physio_hub_flutter/models/Patient.dart';

class PatientController{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Patient>> getPatientsForDoctor(String doctorId) async{
    try{
      //query the firestore for patients with matching doctorId
      QuerySnapshot querySnapshot = await _firestore.collection('patients')
          .where('doctorId', isEqualTo: doctorId)
          .get();
      //convert each of the documents into a patient model
      List<Patient> patients = querySnapshot.docs.map((doc){
        return Patient.fromFirestore(doc);
      }).toList();

      return patients;

    } catch (e) {
      print("Error fetching patients: $e");
      return []; // Return an empty list on error
    }
  }

  Future<String> updatePatientNotes(String patientId, String notes) async{
    try{
      await _firestore.collection('patients').doc(patientId).update({
        'notes': notes,
      });
      return('Patient notes updated.');
    } on FirebaseException catch (e){
      return('Failed to update patient notes.');
    } catch (e) {
      return ('An unexpected error occured');
    }
  }
}