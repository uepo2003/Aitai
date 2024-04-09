import 'package:aitai/providers/state.dart';
import 'package:aitai/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


 void listenForNotifications(String? userId, BuildContext context) {
  FirebaseFirestore.instance
      .collection('notifications')
      .where('toUserId', isEqualTo: userId)
      .where('isRead', isEqualTo: false)
      .snapshots()
      .listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          var notification = snapshot.docs.first;
          showNotificationDialog(notification, context);
        }
      });
}


void showNotificationDialog(QueryDocumentSnapshot notification, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("ライクされました"),
        content: Text("${notification['fromName']}からライクされました。"),
        actions: <Widget>[
          TextButton(
            child: const Text("閉じる"),
            onPressed: () async  {
              await setTrue(notification.id).then((_) => Navigator.of(context).pop());
            },
          ),
            TextButton(
            child: const Text("ありがとう"),
            onPressed: () async {
              setAccept(notification.id, notification['toUserId'], notification['fromUserId']).then((_) => setTrue(notification.id)).then((_) => Navigator.of(context).pop()); 
             
            },
          ),
        ],
      );
    },
  );
}
Future<void> setTrue(String id) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference docRef = firestore.collection("notifications").doc(id);
  await docRef.update({
    "isRead": true, // フィールド名が "isAcept" から "isAccept" に修正されていることに注意
  });
}


Future<void> setAccept(String id, String userId, String likingId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference docRef = firestore.collection("notifications").doc(id);
  await docRef.update({
    "isAccept": true, // フィールド名が "isAcept" から "isAccept" に修正されていることに注意
  });
  DocumentReference userDocRef = firestore.collection("users").doc(userId);
  await firestore.runTransaction((transaction) async {
    DocumentSnapshot snapshot = await transaction.get(userDocRef);
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    List<dynamic> likingIds = data.containsKey("likingIds") ? data["likingIds"] : [];
    debugPrint(likingIds.toString());
    if (!likingIds.contains(likingId)) {
      likingIds.add(likingId);
      transaction.update(userDocRef, {"likingIds": likingIds});
    }
  }); // この行が修正されました
}

//いいね画面

class Favorite extends ConsumerStatefulWidget {
  const Favorite({super.key});

  @override
  ConsumerState<Favorite> createState() => FavoriteState();
  }

class FavoriteState extends ConsumerState<Favorite> {

  @override
  void initState() {
    super.initState();
    // `initState`ではlistenだけを行い、`ref.watch`は`build`で使う。これ大事！！
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final c = ref.read(currentUserProvider);
      listenForNotifications(c,context);
    });
  }

  @override
  Widget build(BuildContext context) {
     final good = Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: const Icon(
        Icons.fmd_good,
        size: 70,
      ),
    );

    const String advice = 'マッチングしたいお相手はいましたか？分割”いいね！”を送ってもっとお相手を見つけましょう！';
    List<String> sentences =
        advice.split('分割').where((sentence) => sentence.isNotEmpty).toList();

    List<Widget> toMakeSpace = sentences
        .map<Widget>((sentence) => Text(sentence,
            softWrap: true,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            )))
        .expand((widget) => [widget, const SizedBox(height: 10)])
        .toList();

    if (toMakeSpace.isNotEmpty) {
      toMakeSpace.removeLast();
    }

    final iineButton = Container(
      margin: const EdgeInsets.only(top: 15),
      child: SizedBox(
        width: 240, //横幅
        height: 40, //高さ
        child: ElevatedButton(
          onPressed: () async {
            debugPrint("早速いいねしてみるボタンが押されましたモーダルを展開します!");
            final answer = await showDialog(
              context: context, 
              builder: (_) => const FabDialog());
              debugPrint(answer);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 238, 127, 209)),
            ),
          child: const Text(
            '早速"いいね！"してみる',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w900
            ),
            ),
        ),
      ),
    );

    final titleCon = Container(
      color: Colors.white,
      height: 70,
      child: const Align(
        alignment: Alignment(-0.9, 0),
        child: Text(
          "いいね!",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    final contentCon = Expanded(
      child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [good, ...toMakeSpace, iineButton],
            //この部分でchildrenのリストに放り込んでるんだ。　理解理解
          )),
    );

    //インテンドで繰り返し問題が発生している次からは気をつけよう!!

    return Scaffold(
      body: Column(
        children: [
          titleCon,
          contentCon,
        ],
      ),
    );
  }
}
