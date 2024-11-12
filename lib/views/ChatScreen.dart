import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  const ChatScreen({required this.receiverId, Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}
