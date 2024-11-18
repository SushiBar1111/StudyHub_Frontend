import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:learn_hub/pages/profile_page.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ChatPage extends StatefulWidget {
  final int convoId;

  const ChatPage({super.key, required this.convoId}); // Simpan convoId sebagai field

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<types.Message> _messages = [];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  final storage = const FlutterSecureStorage();
  String? userId;

  @override
  void initState() {
    super.initState();
    getUserId();
    _getMessagesFromBackend();
  }

  Future<void> _getMessagesFromBackend() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/message/list?convo_id=${widget.convoId}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<types.Message> messages = data.map((item) {
        return types.TextMessage(
          author: types.User(id: item['sender'].toString()),
          createdAt: DateTime.parse(item['timestamp']).millisecondsSinceEpoch,
          id: item['id'].toString(),
          text: item['text'],
        );
      }).toList();

      setState(() {
        _messages.clear();
        _messages.addAll(messages);
      });
    } else {
      print('Gagal mendapatkan pesan: ${response.body}');
    }
  }

  Future<void> _sendMessageToBackend(types.TextMessage message) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/message/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'convo': widget.convoId, // pake convoId dari yang diambil dari page list
        'sender': userId,
        'text': message.text,
        'timestamp': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 201) {
      print('Pesan berhasil dikirim');
    } else {
      print('Gagal mengirim pesan: ${response.body}');
    }
  }

  Future<void> getUserId() async {
    userId = await storage.read(key: 'id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePageContent()),
              );
            },
            child: const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://cdn.pixabay.com/photo/2023/08/24/19/58/saitama-8211499_1280.png'),
              radius: 30,
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.green,
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://cdn.myanimelist.net/images/characters/5/525108.jpg'),
                  radius: 20,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Mr. Stark',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Chat(
              theme: const DefaultChatTheme(
                inputBackgroundColor: Colors.green,
                backgroundColor: Colors.white,
              ),
              bubbleBuilder: _bubbleBuilder,
              onAttachmentPressed: _handleImageSelection,
              messages: _messages,
              onSendPressed: _handleSendPressed,
              user: _user,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubbleBuilder(
      Widget child, {
        required types.Message message,
        required bool nextMessageInGroup,
      }) {
    final isCurrentUser = _user.id == message.author.id;

    if (message is types.TextMessage) {
      return Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isCurrentUser ? Colors.green : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(15),
              topRight: const Radius.circular(15),
              bottomLeft: isCurrentUser ? const Radius.circular(10) : const Radius.circular(0),
              bottomRight: isCurrentUser ? const Radius.circular(0) : const Radius.circular(10),
            ),
          ),
          child: Text(
            message.text,
            style: TextStyle(
              color: isCurrentUser ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return child; // Untuk pesan selain teks
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: randomString(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessage(textMessage);
    _sendMessageToBackend(textMessage); // Kirim pesan ke backend
  }
}
