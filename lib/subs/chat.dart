import 'package:aitai/providers/state.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

//////////////////////////////以下がConsumerStatefulWidgetです!!!!///////////////////////////////////

class ChatScreen extends ConsumerStatefulWidget {
  final String? id;
  //nullを許容しています
  const ChatScreen({super.key, required this.id});
  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends ConsumerState<ChatScreen> {
  //ルール、バックアップ、使用状況をみてエラーを解決できたやったね！！
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _messages = [];

   back(BuildContext context) {
    // 前の画面 へ戻る
    context.pop();
  }

  @override
  void initState() {
    super.initState();

    final DatabaseReference messagesRef = FirebaseDatabase.instanceFor(
            app: Firebase.app(),
            databaseURL:
                'https://amkairi-e464e-default-rtdb.asia-southeast1.firebasedatabase.app')
        .ref("rooms/${widget.id}/messages");

    messagesRef.orderByChild("timestamp").onValue.listen((event) {
      final data = event.snapshot.value as Map;
    
        final messages = data.values.map((messageData) {
          return {
            "text": messageData["text"],
            "userId": messageData["userId"],
             "timestamp": messageData["timestamp"]
          };
        }).toList();

        messages.sort((a, b) => a["timestamp"].compareTo(b["timestamp"]));

        debugPrint(messages.toString());
     
        setState(() {
          _messages = messages;
        });
  
    });
  }

void _sendMessage(String m) {
  if (m.isNotEmpty) {
    final DatabaseReference messagesRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://amkairi-e464e-default-rtdb.asia-southeast1.firebasedatabase.app/')
      .ref("rooms/${widget.id}/messages");
    final String? currenId = ref.watch(currentUserProvider);
    //map化して送信っと
    final newMessage = {'text': m, 'userId': currenId, "timestamp": DateTime.now().microsecondsSinceEpoch};
    messagesRef.push().set(newMessage);
    _controller.clear();
  }
}
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: <Widget>[
          Column(children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 35), // 画面左側に配置するアイコン
              onPressed: () {
               back(context);
              },
            ),
            const SizedBox(height: 10)
          ]),
          Container(width: 100),
          Column(children: [
            Text(
              'Aitai',
              style: GoogleFonts.dancingScript(fontSize: 40),
            ),
            const SizedBox(height: 10)
          ]),
          Container(width: 75),
          Column(children: [
            IconButton(
              icon: const Icon(Icons.settings, size: 35), // 画面右側に配置するアイコン
              onPressed: () {
              },
            ),
            const SizedBox(height: 10)
          ])
          // ここに他のアイコンやウィジェットを配置しても良い
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 234, 109, 151),
    );
      final c = ref.watch(currentUserProvider);
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
                  alignment: message["userId"] == c 
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 14.0),
                    decoration: BoxDecoration(
                      color: message["userId"] == c 
                          ? Colors.blue[100]
                          : Colors.green[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(message["text"]),
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
                  labelText: 'メッセージを送信する', labelStyle: TextStyle(fontSize: 20)),
              onSubmitted: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final String? userId;
  final int? timestamp;

  Message({required this.text, this.userId, this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'userId': userId,
      'timestamp': timestamp
    };
  }
}

//object型を使用する場合、型の情報が失われてしまうため、値をobject型から元の型に戻す場合には明示的なキャストが必要となります。
//dynamic型はコンパイル時の型チェックを回避するため、一部のエラーは実行時に発生する可能性があります。しかし、この柔軟性は、動的に型が変わる場合や、コンパイル時に型が不明確な場合に役立ちます。
//簡単に言えば、コンパイル時はソースコードが解析されて機械語に変換される段階であり、型のチェックやエラーチェックが行われます。一方、実行時はコンパイルされたプログラムが実際に動作し、データが処理される段階であり、動的な振る舞いや実行時エラーが発生する可能性があります。
//クラスとMapの書き方の違い
//コンパイル時に型がわからないからdynamic型を使うと
//返ってくる型を定義したmap関数
//型をしっかり見極める