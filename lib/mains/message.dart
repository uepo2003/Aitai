import 'package:aitai/providers/state.dart';
import 'package:aitai/widgets/icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';


//メッセージ画面

//////////////////////////////////////これがメッセージクラスです！！！?/////////////////////////////////////////
class Message {
  final String imageUrl;
  final String id;
  final String name;
  Message(this.imageUrl, this.id, this.name);

  static Message fromDocumentToMessage(DocumentSnapshot doc){
    return Message(
      doc['image'] as String,
      doc.id, 
      doc["name"] as String
    );
  }
}

//////////////////////////////////////以下がライクしているユーザーを読み込む関数を含むクラスです！！///////////////////////////

class FireRead {
  Future<List<Message>> read(WidgetRef ref) async{
    final db = FirebaseFirestore.instance;
    final cu = ref.watch(currentUserProvider);
    final sn = await db.collection("users").doc(cu).get();
    final List<String> likeIds = List.from(sn.get("likingIds"));
    List<Message> messages = [];
    for(String id in likeIds){
    final snapshot = await db.collection("users").doc(id).get();
    if(snapshot.exists){
      messages.add(Message.fromDocumentToMessage(snapshot));
      //snapshot
    }
    }
    //for文の処理が終わったら以下の処理が実行される
    return messages;
  }
}

////////////////////////////////////以下がルーム作成をする関数です！！！！/////////////////////////////////

Future<String?> createRoom(List<String?> roomData) async {
  final dbRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(), 
    databaseURL: 'https://amkairi-e464e-default-rtdb.asia-southeast1.firebasedatabase.app/'
  ).ref();

  DataSnapshot snapshot = await dbRef.child("rooms").get();
  final Map rooms = snapshot.value as Map;

  List<dynamic>? roomIds = rooms.keys.toList();
//nullを許容しています
  for (var roomId in roomIds) {
    var room = rooms[roomId];
    if (room != null) {
      List<Object?>? r = room["participants"] as List<Object?>?;
      if (r != null) {
        var sortedR = List.from(r)..sort();
        var sortedRoomData = List.from(roomData)..sort();

        bool areEqual = sortedR.toString() == sortedRoomData.toString();

        if (areEqual) {
          debugPrint("ルームはすでに存在しています");
          String existingRoomKey = roomId.toString();
          debugPrint(existingRoomKey);
          return existingRoomKey;
        }
      }
    }
  }
  var uuid = const Uuid();
  String randomUuid = uuid.v4();
  await dbRef.child("rooms/$randomUuid").set({
    "participants": roomData,
  });
  debugPrint(randomUuid);
  return randomUuid;
}

///////////////////////////////////以下が縦スクロールウィジェットです！！！///////////////////////////////////////

Widget tateScrollToWidget(Message model, WidgetRef ref, BuildContext context) {
  final icon = Container(
    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
    width: 80,
    height: 80,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
    ),
    child: ClipOval(
      child: Image.network(
        model.imageUrl, // TwitterアイコンのURLを指定
        fit: BoxFit.cover, // 画像がコンテナにぴったり合うように調整
      ),
    ),
  );

  final meta = Container(
    padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
    height: 40,
    alignment: Alignment.centerLeft,
    child: const Text(
      'マッチング日 2/3',
      style:  TextStyle(color: Colors.grey),
    ),
  );

  final text = Container(
    padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
    height: 40,
    alignment: Alignment.centerLeft,
    child: Text(
      model.name,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  );

  return InkWell(
    onTap: () async {
    final c = ref.watch(currentUserProvider);
    debugPrint(c);
    debugPrint(model.id);
    try{
    createRoom([c, model.id.toString()]).then((value) {context.push('/chat/$value');});
 
    }catch(e){
      debugPrint("エラーが発生しました$e");
    }

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


/////////////////////////////////////////以下がConsumerStatefulWidgetです!!!//////////////////////////////


class Messages extends ConsumerStatefulWidget {
  const Messages({super.key});

  @override
  MessagesState createState() => MessagesState();
}


class MessagesState extends ConsumerState<Messages> {

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

   final  messagesFuture = fire.read(ref);

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
                child: tateScrollToWidget(messages[index],ref, context)
              );
            }
            );
        } else {
          return const Text("現在likeしているユーザーが存在しません");
        }
      } else {
        return const CircularProgressIndicator();
      }
    }
   );


   final icons = FutureBuilder<List<Message>>(
    future: messagesFuture,
    builder: (context, snapshot){
      if(snapshot.connectionState == ConnectionState.done){
        if(snapshot.hasError){
          return Text("Error: ${snapshot.error}");
        }
        if(snapshot.hasData){
          final icons = snapshot.data!;
              return ExportIcons(icons: icons);
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
            backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 238, 127, 209)),
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
            icons, 
            premiumCon,
            con
            ],
        ));
  }
}

//なんとなくコードの意味を理解しました
