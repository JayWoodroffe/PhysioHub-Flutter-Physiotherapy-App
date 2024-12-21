import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final Timestamp timestamp;
  bool read;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    this.read = false,
  });

  // Convert Firestore document to Message object
  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    return ChatMessage(
      id: doc.id,
      senderId: doc['senderId'],
      receiverId: doc['receiverId'],
      text: doc['message'],
      timestamp: doc['timestamp'],
      read: doc['read'],
    );
  }

  // Convert Message object to map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': text,
      'timestamp': timestamp,
      'read': read,
    };
  }
}
