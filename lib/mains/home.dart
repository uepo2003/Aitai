
import 'package:aitai/providers/state.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class ProfileImage {
  final String imageUrl;
  final String userId;
  ProfileImage(this.imageUrl, this.userId);
  static ProfileImage fromDocumentToProfileImage(DocumentSnapshot doc){
    return ProfileImage(
      doc['image'] as String,
      doc.id 
    );
  }
}


Future<void> addLiking(String? userId, String likingId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference userDocRef = firestore.collection("users").doc(userId);
    await firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userDocRef);
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<dynamic> likingIds = data.containsKey("likingIds") ? data["likingIds"] : [];
      debugPrint(likingIds.toString());
      if(!likingIds.contains(likingId)){
        likingIds.add(likingId);
        transaction.update(userDocRef, {"likingIds": likingIds});
  
        await firestore.collection("notifications").add({
        "toUserId": likingId, // 通知を受けるユーザーID
        "fromUserId": userId, // ライクしたユーザーID
        "type": "like",
        "fromName": data["name"],
         // 通知の種類
        "isRead": false, 
        "isAccept": false,
        "timestamp": FieldValue.serverTimestamp(), // 通知のタイムスタンプ
      });
      }
    }); 
  }


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyHome();
  }
}


class MyHome extends ConsumerStatefulWidget {
  const MyHome({super.key});

  @override
  ConsumerState<MyHome> createState() => MyHomeState();
}

//ホーム画面
class MyHomeState extends ConsumerState<MyHome> with TickerProviderStateMixin{
  AnimationController? _controller;

  List<Map<String,dynamic>>images = [];
  
  int currentIndex = 0;

  Set<String> displayedImageUserIds = {}; 
  bool noMoreImages = false; 
  Future? _imageLoadFuture;

  @override
  void initState() {

    super.initState();
    _controller = AnimationController(
      duration: const Duration(microseconds: 5),
      vsync: this);

       _imageLoadFuture = readImageUrl();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();

  }

  Future<void> _next(String buttonType, String likingId) async {
      if(currentIndex < images.length -1) {
       setState(() {
        currentIndex++;
         });
      _controller?.forward(from: 0.0);
      } else if(currentIndex >= images.length - 1 && !noMoreImages) {
    setState(() {
      noMoreImages = true; 
    });
  }  

      if(buttonType == "A"){
        String? currentU = ref.watch(currentUserProvider);
        debugPrint(currentU);
        try{
        await addLiking(currentU, likingId);
        }catch (e) {

          debugPrint("エラーが発生しましたみんな逃げろ！！！$e");
        }
      }
  }

  @override
  Widget build(BuildContext context){

    if (noMoreImages) {
    return const Center(child: Text("これ以上画像がありません"));
   }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 227, 148, 175),
        ),
        child:  FutureBuilder(
          future: _imageLoadFuture, 
          builder: (BuildContext contet, AsyncSnapshot snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            } else if(snapshot.hasError) {
              return const Center(child: Text("エラーが発生しました"));
            } else {
              return images.isNotEmpty ? _buildImageWidget() : const Center(child: Text("画像がありません"));
            }    
          }),
      )
    );

  }

   Future<void> readImageUrl() async{
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("users").get();
    final c = ref.watch(currentUserProvider);
    final im = snapshot.docs.where((doc) => doc.id != c).map((doc) =>  {"imageUrl":doc["image"],"userId": doc.id}).toList();
    debugPrint(images.toString());
    setState(() {
      images = im;
    });
  }


  Widget _buildImageWidget() {
    final stack = Stack(
      alignment: Alignment.center,
      children: [

        AnimatedBuilder(
          animation: _controller!,
          builder: (_, child) {
            return Transform.scale(
              scale: 1.0,
              child: child
            );
          },
          child: Container(
            width: 360,
            height: 620,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(images[currentIndex]["imageUrl"].toString()), // 画像のパスを指定
                  fit: BoxFit.cover, // 画像をコンテナにぴったり合わせる
                ),
                ), 
          ),
        ),
        Align(
          alignment: const Alignment(0.67, 0.79),
          child: SizedBox(
              width: 80,
              height: 80,
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 243, 125, 164),
                onPressed: () {
                  _next("A", images[currentIndex]["userId"].toString());
                } ,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.favorite,
                  size: 50,
                  color: Colors.white,
                ),
              )),
        ),
        Align(
          alignment: const Alignment(-0.67, 0.79),
          child: SizedBox(
              width: 80,
              height: 80,
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 243, 125, 164),
                onPressed:() {
                  _next("B",images[currentIndex]["userId"].toString());
                } ,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.clear,
                  size: 50,
                  color: Colors.white,
                ),
              )),
        ),
      ],
    );
    return Container(
      child: stack
    );
  }
}

//firebaseとgcsの連携？？

//flutter_hookはstatelessWidgetに近い形でフックを使用するライブラリのためStatefulWidgetとの混在は推奨されていない
//                                       ↓
//    アニメーションコントローラのような複雑な状態を持つ場合、標準のStatefulWidgetの使用が適切


// FlutterではuseEffectというフックは直接存在しませんが、useEffectの概念に似た挙動を実現する方法はあります。

// useEffectはReactのフックの一つで、コンポーネントがレンダリングされた後に何らかの副作用（例えばデータのフェッチや購読の設定など）を実行するために使われます。

// Flutterで類似の機能を実現するには、initState、didChangeDependencies、disposeなどのライフサイクルメソッドを使用します。

//FlutterのStatefulWidgetにおいて、initStateメソッドはウィジェットがウィジェットツリーに挿入された時に一度だけ呼ばれるため、副作用を実行する初期化処理に適しています。

//また、disposeメソッドはウィジェットがウィジェットツリーから恒久的に削除されるときに呼ばれるため、購読解除などのクリーンアップ処理に適しています。