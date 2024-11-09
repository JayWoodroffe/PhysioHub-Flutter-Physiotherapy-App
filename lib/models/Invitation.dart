import 'package:cloud_firestore/cloud_firestore.dart';

class Invitation{
  String code;
  String doctorId;
  DateTime validUntil;

  Invitation({
    required this.code,
    required this.doctorId,
    required this.validUntil,
  });

  //from firebase to model
  factory Invitation.fromFirestore(DocumentSnapshot doc){
    final data = doc.data() as Map<String, dynamic>;
    return Invitation(
      code: data['code'] ?? '',
      doctorId: data['doctorId'] ?? '',
      validUntil: (data['validUntil'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore(){
    return {
      'code': code,
      'doctorId': doctorId,
      'validUntil': validUntil,
    };
  }
}