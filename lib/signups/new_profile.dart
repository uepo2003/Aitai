//初回登録時のプロフィール入力画面
import 'package:aitai/providers/create.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// StatefulWidgetを継承したSpeechScreenクラス
class SpeechScreen extends ConsumerStatefulWidget {
  const SpeechScreen({super.key});

  @override
  ConsumerState<SpeechScreen> createState() => SpeechScreenState();
}


// SpeechScreenクラスの状態を管理するためのクラス
class SpeechScreenState extends ConsumerState<SpeechScreen> {

  push(BuildContext context) {
    context.push('/');
  }

  SpeechToText speechToText = SpeechToText();
  TextEditingController textEditingController = TextEditingController();
  var isListening = false;

 @override
  void initState() {
    super.initState();
    textEditingController.text = "あなたのプロフィールを入力してね";
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  // ユーザーにエラーメッセージを表示するメソッド
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  //スナックバー

  // SpeechToTextの初期化とエラーハンドリング
  Future<void> initializeSpeech() async {
    try {
      var available = await speechToText.initialize(
        onError: (val) => showError("音声認識エラー: $val"),
        onStatus: (val) => debugPrint("onStatus: $val"),
      );
      if (!available) {
        showError("音声認識は利用できません");
        return;
      }
      startListening();
    } catch (e) {
      showError("音声認識の初期化中にエラーが発生しました: $e");
    }
  }

  // 聞き取り開始
  void startListening() {
    setState(() {
      isListening = true; 
    });
    speechToText.listen(
      onResult: (result) {
        setState(() {
          textEditingController.text = result.recognizedWords;
        });
      },
      localeId: 'ja_JP',
    );
  }

  // Firestoreへのデータ保存処理とエラーハンドリング
  Future<void> saveToFirestore() async {
    try {
      final n = ref.watch(createNotifierProvider.select((state) => state.name));
      final a = ref.watch(createNotifierProvider.select((state) => state.age));
      final i = ref.watch(createNotifierProvider.select((state) => state.image));
      final p = ref.watch(createNotifierProvider.select((state) => state.profile));

      final create = FireDB();
      await create.create(n, a, i, p, ref).then((value) {
        push(context);
      });
    } catch (e) {
      showError("データの保存に失敗しました: $e");
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // フローティングアクションボタンの位置を指定
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      // AvatarGlowを利用して、ボタンにグロー効果を追加
      floatingActionButton: AvatarGlow(
        endRadius: 75.0,
        animate: isListening, // isListeningがtrueの場合、アニメーションする
        duration: const Duration(milliseconds: 2000),
        glowColor: const Color.fromARGB(31, 12, 199, 15),
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          // タップを押し始めたときの処理
          onTapDown: (details) async {
         if (!isListening) {
           await initializeSpeech();
           }
         },
          // タップを離したときの処理
          onTapUp: (details) {
            setState(() {
              isListening = false;
            });
            speechToText.stop();
          },
          child: CircleAvatar(
            backgroundColor: Colors.green,
            radius: 35,
            child: Icon(
              isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
            ),
          ),
      ),

      ),
    
      // 本文の設定
      body: Container(
        decoration:const BoxDecoration(
        image: DecorationImage(
        image: AssetImage("assets/images/29117172S.jpg"), 
        fit: BoxFit.cover,
        ),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height:350
            ),
            TextField(
              controller: textEditingController,
              maxLines: null,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
                focusedBorder: OutlineInputBorder(  
                borderSide: BorderSide(
                color: Color.fromARGB(255, 238, 235, 225),
               )
                ),
              ),
            ),

            
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
              final read = ref.watch(createNotifierProvider.notifier);
              read.updateProfile(textEditingController.text);
              },
              child: const Text('保存する', style:  TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),),
            ),

            ElevatedButton(
              onPressed: () async {
               await saveToFirestore();
            },
              child: const Text('さあ新たな旅に出ましょう！！', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500)),
            ),

            
          ],
        ),
      ),
    );
  }
}









//スコープに関するエラーが発生しました次回からは気を付けよう！！