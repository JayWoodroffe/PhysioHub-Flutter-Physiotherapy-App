import 'package:flutter_test/flutter_test.dart';
import 'package:physio_hub_flutter/models/ChatMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate a MockDocumentSnapshot
@GenerateMocks([DocumentSnapshot])
import 'chatmessage_test.mocks.dart';

void main() {
  group('ChatMessage Model Tests', () {
    test('ChatMessage fromFirestore creates a ChatMessage object correctly', () {
      // Create a mock DocumentSnapshot
      final mockDoc = MockDocumentSnapshot();

      // Prepare test data
      final messageData = {
        'senderId': 'doctorId',
        'receiverId': 'patientId',
        'message': 'Hello!',
        'timestamp': Timestamp.now(),
        'read': false,
      };

      // Setup the mock to return data and id
      when(mockDoc.id).thenReturn('testId');
      when(mockDoc.data()).thenReturn(messageData);

      // Create ChatMessage from mock snapshot
      final chatMessage = ChatMessage.fromFirestore(mockDoc);

      // Verify the chat message properties
      expect(chatMessage.id, 'testId');
      expect(chatMessage.senderId, 'doctorId');
      expect(chatMessage.receiverId, 'patientId');
      expect(chatMessage.text, 'Hello!');
      expect(chatMessage.read, false);
    });

    test('ChatMessage fromFirestore handles null data gracefully', () {
      // Create a mock DocumentSnapshot
      final mockDoc = MockDocumentSnapshot();

      // Setup the mock to return null data
      when(mockDoc.id).thenReturn('testId');
      when(mockDoc.data()).thenReturn(null);

      // Create ChatMessage from mock snapshot
      final chatMessage = ChatMessage.fromFirestore(mockDoc);

      // Verify the chat message properties use default values
      expect(chatMessage.id, 'testId');
      expect(chatMessage.senderId, '');
      expect(chatMessage.receiverId, '');
      expect(chatMessage.text, '');
      expect(chatMessage.read, false);
    });
  });
}