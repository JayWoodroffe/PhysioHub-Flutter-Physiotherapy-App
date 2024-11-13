import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/ChatMessage.dart';

class ChatMessageController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String doctorId;
  final String patientId;

  late final CollectionReference messagesRef;
  // Constructor to accept doctorId and patientId
  ChatMessageController({
    required this.doctorId,
    required this.patientId,
  }){
    messagesRef = _firestore
        .collection('messages')
        .doc(doctorId) // Doctor's document
        .collection(patientId); // Patient's subcollection
  }

  //function to send messages
  Future<void> sendMessage({ required String message}) async {
    try {
      final messageRef = messagesRef
          .doc(); //generate a new document

      await messageRef.set({
        'senderId': doctorId,
        'receiverId': patientId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false, // initially unread
      });
    } catch (e) {
      print('error sending message $e');
    }
  }

  //function to fetch messages between doctor and patient
  Stream<List<ChatMessage>> getMessages() {

    return messagesRef
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {

      return snapshot.docs.map((doc) {
        print("Message fetched: ${doc['message']}");
        return ChatMessage.fromFirestore(doc);
      }).toList();
    });
  }

  //function to mark a message as read
  Future<void> markMessageAsRead({required String messageId}) async{
    try{
      await messagesRef
          .doc(messageId)
          .update({'read': true});
    }
    catch(e){
      print("Error marking message as read: $e");
    }
  }

  //function to get unread message count for a specific doctor-patient pair
  Future<int> getUnreadMessageCount() async{
    try{
      final snapshot = await messagesRef
          .where('read', isEqualTo: false)
          .get();
      return snapshot.docs.length;
    }catch (e) {
      print("Error fetching unread messages count: $e");
      return 0;
    }
  }
}
