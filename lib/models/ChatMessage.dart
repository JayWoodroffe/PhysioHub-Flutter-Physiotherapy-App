import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage{
  String senderId;
  DateTime timeStamp;
  String content;

  ChatMessage({
    required this.senderId,
    required this.timeStamp,
    required this.content
  });

  //from firebase format to model
  factory ChatMessage.fromMap(Map<String, dynamic> data) {
    return ChatMessage(
      senderId: data['senderId'] ?? '',
      content: data['text'] ?? '',
      timeStamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': content,
      'timestamp': timeStamp,
    };
  }
}