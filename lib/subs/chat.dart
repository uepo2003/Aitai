import 'package:aitai/providers/state.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';




class Chat extends StatelessWidget {
  const Chat({super.key});

    @override
  Widget build(BuildContext context) {
    return const ChatScreen();
  }
}


class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});


  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends ConsumerState<ChatScreen> {
  final DatabaseReference _messagesRef = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: 'https://appmatching-416311-default-rtdb.firebaseio.com').ref("messages");
  //ルール、バックアップ、使用状況をみてエラーを解決できたやったね！！
  final TextEditingController _controller = TextEditingController();
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _messagesRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
    if(data != null){
      final messages = data.values.map<Message>((messageData) {
        final String? currentUserId = ref.watch(currentUserProvider);
        final isCurrentUser = messageData["userId"] as String == currentUserId ? true : false;
        return Message(
          text: messageData["text"] as String,
          isMe: isCurrentUser,
          userId: messageData["userId"] as String
        );
      }).toList();

      debugPrint(messages.toString());

      setState(() {
        _messages = messages;
      });
    }

    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
    title: Row(
    children: <Widget>[
      Column(
      children: [
        IconButton(
        icon: const Icon(
          Icons.menu,
          size: 35
        ), // 画面左側に配置するアイコン
        onPressed: () {
          // アイコンボタンの動作
         
        },
      ),
      const SizedBox(
        height: 10
      )
      ]
      ),
      Container(
        width: 100
      ),
      Column(
      children: [
        Text(
          'Aitai',
          style: GoogleFonts.dancingScript(fontSize: 40),
        ),
      const SizedBox(
        height: 10
      )
      ]
      ),
      Container(
        width: 75
      ),
       Column(
      children: [
        IconButton(
        icon: const Icon(
          Icons.settings,
          size: 35
        ), // 画面左側に配置するアイコン
        onPressed: () {
          // アイコンボタンの動作
        },
      ),
      const SizedBox(
        height: 10
      )
      ]
      )
      // ここに他のアイコンやウィジェットを配置しても良い
    ],
  ),
            backgroundColor: const Color.fromARGB(255, 234, 109, 151),
  );
     return Scaffold(
      appBar: appBar,
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.isMe!=null ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
                    decoration: BoxDecoration(
                      color: message.isMe!=null ? Colors.blue[100] : Colors.green[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(message.text),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'メッセージを送信する',
                labelStyle: TextStyle(
                  fontSize: 20
                )
              
              ),
              onSubmitted: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }


  void _sendMessage(String m) {
    if (m.isNotEmpty) {
      final String? currenId = ref.watch(currentUserProvider);
      final newMessage = Message(text: m, userId: currenId); // ここで、isMeをtrueに設定
      _messagesRef.push().set(newMessage.toMap());
      _controller.clear();
    }
  }
}

class Message {
  final String text;
  final bool? isMe;
  final String? userId;

  Message({required this.text, this.isMe,this.userId});

  Map<String, String> toMap() {
    return {
      'text': text,
    };
  }
}