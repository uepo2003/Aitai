// import 'package:aitai/providers/read.dart';

import 'package:aitai/widgets/icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
//メッセージ画面

const importIcons = ExportIcons();

class Message {
  final String username;
  final String iconUrl;
  final String text;
  final String createdAt;

  Message(this.username, this.iconUrl, this.text, this.createdAt);

  static Message fromDocumentToMessage(DocumentSnapshot doc){
    return Message(
      doc['username'] as String,
      doc['iconUrl'] as String,
      doc['text'] as String,
      doc['createdAt'] as String,
    );
  }
}

class FireRead {
  Future<List<Message>> read() async{
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("profiles").get();
    final ms = snapshot.docs.map((doc) => Message.fromDocumentToMessage(doc)).toList();
    final List<String> ms2 = ms.map((e) => e.username).toList();
    debugPrint('ちょっと中身がどうなっているのか気になったので実験中です: $ms2');
    return ms;
  }

}





Widget tateScrollToWidget(Message model) {
  final icon = Container(
    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
    width: 80,
    height: 80,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
    ),
    child: ClipOval(
      child: Image.asset(
        'assets/images/myedit_ai_image02.jpg', // TwitterアイコンのURLを指定
        fit: BoxFit.cover, // 画像がコンテナにぴったり合うように調整
      ),
    ),
  );

  final meta = Container(
    padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
    height: 40,
    alignment: Alignment.centerLeft,
    child: Text(
      '${model.username} ${model.createdAt}',
      style: const TextStyle(color: Colors.grey),
    ),
  );

  final text = Container(
    padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
    height: 40,
    alignment: Alignment.centerLeft,
    child: Text(
      model.text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  );

  return InkWell(
    onTap: () {

      debugPrint('メッセージをタップしました。');
    },
    child: Ink(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        height: 90,
        width: double.infinity,
        child: Row(
          children: [
            icon,
            Expanded(
              child: Column(
                children: [
                  meta,
                  text,
                ],
              ),
            )
          ],
        )),
  );
}

class Messages extends HookWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    
    final titleCon = 
      Container(
      padding: const EdgeInsets.only(bottom: 10),
      color: Colors.white, 
      height: 60,
      width: double.infinity,
      child: const Align(
      alignment: Alignment(-0.9, 0),
      child: Text(
        'メッセージ',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w600,
        ),
        ),
        ),
    );

    final matchingCon = Container(
      width: double.infinity,
      height: 22,
      color: Colors.white,
      child: const Align(
        alignment: Alignment(-0.9, 0),
        child: Text(
          "マッチング",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600
          )),
      ),
    );

   final fire = FireRead();

   final  messagesFuture = fire.read();

   final list = FutureBuilder<List<Message>>(
    future: messagesFuture,
    builder: (context, snapshot){
      if(snapshot.connectionState == ConnectionState.done){
        if(snapshot.hasError){
          return Text("Error: ${snapshot.error}");
        }
        if(snapshot.hasData){
          final messages = snapshot.data!;
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return Container(
                child: tateScrollToWidget(messages[index])
              );
            }
            );
        } else {
          return const Text("No data available");
        }
      } else {
        return const CircularProgressIndicator();
      }
    }
   );
   
    final premiumCon = Stack(
     children: <Widget>[ 
      Container(
      height: 80,
      color: Colors.white
      ),
      Positioned(
      left: 70,
      top: 15,
      child: SizedBox(
        width: 240, //横幅
        height: 50, //高さ
        child: ElevatedButton(
          onPressed: () {
          
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 238, 127, 209)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), // ボーダーラジアスを設定
                // ボーダーラインを設定する場合はこちらを追加
                // side: BorderSide(color: Colors.red, width: 2.0),
                ),
               ),
            ),
          child: const Text(
            'プレミアム会員に登録',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900
            ),
            ),
        ),
      ),
      ),
      ],
    );
//decorationのカラーとcontainerのカラーは同時に使えない
    final con = Expanded(
        child: SizedBox(
        child: list,
    ));

    return Scaffold(
        backgroundColor: Colors.grey,
        body: Column(
          children: [
            titleCon,
            matchingCon,
            importIcons, 
            premiumCon,
            con
            ],
        ));
  }
}
