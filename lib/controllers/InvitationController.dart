import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Invitation.dart';

class InvitationController
{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> createInvitation(String doctorId) async{
    String code = await uniqueCode();
    DateTime validUntil = expirationDate();

    Invitation newInvitation = new Invitation(code: code, doctorId: doctorId, validUntil: validUntil);
    try{
      await _firestore.collection('invitations').add(newInvitation.toFirestore());
      return code;
    }on FirebaseException catch (e) {
      print('Failed to add appointment: $e');
      return null;
    } catch (e) {
      print('An unexpected error occurred: $e');
      return null;
    }
  }

  DateTime expirationDate(){
    DateTime now = DateTime.now();
    return now.add(Duration(days: 5));
  }

  Future<String> uniqueCode() async{
    bool newCodeGenerated = false;
    String newCode;
    do {
      var r = Random();
      const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
      newCode = List.generate(
          6, (index) => _chars[r.nextInt(_chars.length)]).join();

      //check if code is unique
      try {
        QuerySnapshot querySnapshot = await _firestore
            .collection('invitations')
            .where('code', isEqualTo: newCode)
            .get();
        if (querySnapshot.docs.isEmpty) newCodeGenerated = true;

      }
      catch(e){
        print("Error checking code: $e");
      }
    }while(!newCodeGenerated);
    return newCode;
  }
}