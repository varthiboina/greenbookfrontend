import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:greenbook/models/UserProfile.dart';
import 'package:greenbook/utils/Services/auth_services.dart';
import 'package:greenbook/utils/Services/database_service.dart';
import 'package:greenbook/models/chat.dart';
import 'package:greenbook/models/message.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
// lib/utils/Services/database_service.dart

// lib/utils/chat_helpers.dart

final GetIt _getIt = GetIt.instance;

Future<void> accessChatWithProfile(BuildContext context, String uid) async {
  final DatabaseService _databaseService = _getIt.get<DatabaseService>();
  final AuthService _authService = _getIt.get<AuthService>();

  try {
    // Fetch the profile based on the uid
    final UserProfile? profile =
        await _databaseService.getUserProfileByUid(uid);

    if (profile != null) {
      print("inaccesswithchatwithprofileid");
      final chatExists = await _databaseService.checkChatIdExists(
          _authService.user!.uid, profile.uid!);
      if (!chatExists) {
        await _databaseService.createNewChat(
            _authService.user!.uid, profile.uid!);
      }
      // Navigate to the ChatDetailPage with the fetched profile
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatDetailPage(chatUser: profile),
        ),
      );
    } else {
      // Handle the case where no profile is found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No profile found for UID: $uid')),
      );
    }
  } catch (e) {
    // Handle any errors that occur
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error accessing chat: $e')),
    );
  }
}

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late DatabaseService _databaseService;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _databaseService = _getIt.get<DatabaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Page'),
      ),
      body: FutureBuilder<List<UserProfile>>(
        future: _getProfilesWithChatHistory(),
        builder:
            (BuildContext context, AsyncSnapshot<List<UserProfile>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No profiles with chat history found'));
          }

          final profiles = snapshot.data!;

          return ListView.builder(
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              final UserProfile profile = profiles[index];

              return ListTile(
                leading: profile.pfpURL != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(profile.pfpURL!),
                        radius: 35,
                      )
                    : const CircleAvatar(
                        child: Icon(Icons.person),
                        radius: 35,
                      ),
                title: Text(
                  profile.name ?? 'No Name',
                  style: const TextStyle(fontSize: 25),
                ),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatDetailPage(chatUser: profile),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<UserProfile>> _getProfilesWithChatHistory() async {
    final QuerySnapshot<UserProfile> snapshot =
        await _databaseService.userProfiles().first;
    final List<UserProfile> allProfiles =
        snapshot.docs.map((doc) => doc.data()).toList();
    List<UserProfile> profilesWithChat = [];

    for (UserProfile profile in allProfiles) {
      bool chatExists = await _databaseService.checkChatIdExists(
          _authService.user!.uid, profile.uid!);
      if (chatExists) {
        profilesWithChat.add(profile);
      }
    }

    return profilesWithChat;
  }
}

class ChatDetailPage extends StatefulWidget {
  final UserProfile chatUser;

  const ChatDetailPage({Key? key, required this.chatUser}) : super(key: key);

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  ChatUser? currentUser, otherUser;
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late DatabaseService _databaseService;
  final TextEditingController _messageController = TextEditingController();

  // Store the last displayed date to control when to show the date
  DateTime? _lastDisplayedDate;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _databaseService = _getIt.get<DatabaseService>();
    currentUser = ChatUser(
      id: _authService.user!.uid,
      firstName: _authService.user!.displayName,
    );
    otherUser = ChatUser(
      id: widget.chatUser.uid!,
      firstName: widget.chatUser.name,
      profileImage: widget.chatUser.pfpURL,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.chatUser.name ?? 'Chat',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessagesList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return StreamBuilder<DocumentSnapshot<Chat>>(
      stream: _databaseService.getChatData(currentUser!.id, otherUser!.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading chat data'));
        }

        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return Center(child: Text('No chat data found'));
        }

        Chat? chat = snapshot.data?.data();
        List<ChatMessage> _messages = [];
        if (chat != null && chat.messages != null) {
          _messages = generateListOfMessages(chat.messages!);
        }

        return ListView.builder(
          reverse: true,
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            final message = _messages[index];
            final showDate = _shouldShowDate(message.createdAt);
            final isCurrentUser = message.user.id == currentUser!.id;

            return Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (showDate)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      _formatDate(message.createdAt),
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ),
                Align(
                  alignment: isCurrentUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth:
                            250, // Adjust this value to control the max width
                      ),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isCurrentUser
                            ? Colors.blueAccent
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.text,
                            style: TextStyle(
                              color:
                                  isCurrentUser ? Colors.white : Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            _formatTime(message.createdAt),
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onSubmitted: (text) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    Message message = Message(
      senderID: currentUser!.id,
      content: messageText,
      messageType: MessageType.Text,
      sentAt: Timestamp.now(),
    );

    await _databaseService.sendChatMessage(
      currentUser!.id,
      otherUser!.id,
      message,
    );

    _messageController.clear();
  }

  List<ChatMessage> generateListOfMessages(List<Message> messages) {
    List<ChatMessage> chatMessages = messages.map((e) {
      final content = e.content ?? '[No Content]';
      return ChatMessage(
        user: e.senderID == currentUser!.id ? currentUser! : otherUser!,
        text: content,
        createdAt: e.sentAt!.toDate(),
      );
    }).toList();
    chatMessages.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    return chatMessages;
  }

  bool _shouldShowDate(DateTime dateTime) {
    if (_lastDisplayedDate == null) {
      _lastDisplayedDate = _truncateToDate(dateTime);
      return true;
    }
    final currentDate = _truncateToDate(dateTime);
    if (currentDate.isAfter(_lastDisplayedDate!)) {
      _lastDisplayedDate = currentDate;
      return true;
    }
    return false;
  }

  DateTime _truncateToDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}
