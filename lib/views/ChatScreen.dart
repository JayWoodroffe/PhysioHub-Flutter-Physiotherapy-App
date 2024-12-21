import 'package:flutter/material.dart';
import 'package:physio_hub_flutter/controllers/ChatMessageController.dart';
import 'package:intl/intl.dart';
import '../models/ChatMessage.dart';

class ChatScreen extends StatefulWidget {
  final String doctorId;
  final String patientId;

  const ChatScreen({required this.doctorId, required this.patientId, Key? key})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatMessageController _messageController;
  final _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messageController = ChatMessageController(
        doctorId: widget.doctorId, patientId: widget.patientId);
  }

  //fetch the messages for the current chat
  Stream<List<ChatMessage>> getMessagesStream() {
    print('Fetching messages for doctor ${widget.doctorId} and patient ${widget.patientId}');
    return _messageController.getMessages();
  }

  //send a message
  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      await _messageController.sendMessage(message: _controller.text);
      _controller.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    // Scroll to the latest message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _markMessagesAsRead(List<ChatMessage> unreadMessages) {
    if (_messageController != null) {
      final unreadMessageIds = unreadMessages.map((msg) => msg.id).toList();
      _messageController!.markMessagesAsRead(unreadMessageIds);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: getMessagesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print("Waiting for data...");
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print("Error: ${snapshot.error}");
                  return Center(child: Text("Error loading messages"));
                }

                if (snapshot.hasData) {
                  print("Snapshot received with ${snapshot.data!.length} messages");
                } else {
                  print("Snapshot has no data");
                }

                final messages = snapshot.data!;
                // Filter unread incoming messages and mark them as read
                final unreadIncomingMessages = messages
                    .where((message) => message.senderId != widget.doctorId && !message.read)
                    .toList();

                if (unreadIncomingMessages.isNotEmpty) {
                  _markMessagesAsRead(unreadIncomingMessages);
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true, //show latest messages at the bottom
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final bool isOutgoing = message.senderId == widget.doctorId;
                    final bool isRead = message.read;

                    return Align(
                      alignment: isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
                      child: Padding(
                        padding: isOutgoing
                        //so the messages appear either left or right aligned on the screen
                            ? const EdgeInsets.only(left: 80, right: 5, top: 5, bottom: 5)
                            : const EdgeInsets.only(left: 5, right: 80, top: 5, bottom: 5),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7, // Max width for bubble
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isOutgoing ? Color(0xFFD9DBFF) : Color(0xFFD9F2C9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.text,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isOutgoing ? Colors.black : Colors.black,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                       MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      DateFormat('HH:mm').format(message.timestamp.toDate()), // Format the time
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isOutgoing ? Colors.grey.shade700 : Colors.grey,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    if(isOutgoing)
                                      Icon(
                                      isRead ? Icons.check_circle : Icons.check,
                                      size: 20,
                                      color: isRead ? Theme.of(context).primaryColor : Colors.grey,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            //
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Message',
                      hintStyle: TextStyle(color: Theme.of(context).splashColor),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
