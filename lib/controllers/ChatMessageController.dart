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
  }) {
    messagesRef = _firestore
        .collection('messages')
        .doc(doctorId) // Doctor's document
        .collection(patientId); // Patient's subcollection
  }

  //function to send messages
  Future<void> sendMessage({required String message}) async {
    try {
      final messageRef = messagesRef.doc(); //generate a new document

      await messageRef.set({
        'senderId': doctorId,
        'receiverId': patientId,
        'message': message,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
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
        return ChatMessage.fromFirestore(doc);
      }).toList();
    });
  }

  //function to mark messages as read
  Future<void> markMessagesAsRead(List<String> messageIds) async {
    final batch = _firestore.batch();
    for (var messageId in messageIds) {
      final messageRef = messagesRef.doc(messageId);
      batch.update(messageRef, {'read': true});
    }
    await batch.commit();
  }


  // Stream to get unread message count in real-time
  Stream<int> getUnreadMessageCountStream() {
    return messagesRef
        .where('read', isEqualTo: false)
        .where('receiverId', isEqualTo: doctorId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
