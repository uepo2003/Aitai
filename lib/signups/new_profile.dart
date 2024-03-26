//初回登録時のプロフィール入力画面
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:go_router/go_router.dart';

// StatefulWidgetを継承したSpeechScreenクラス
class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

// SpeechScreenクラスの状態を管理するためのクラス
class _SpeechScreenState extends State<SpeechScreen> {

  push(BuildContext context) {
    context.push('/home');
  }


  SpeechToText speechToText = SpeechToText();

  TextEditingController textEditingController = TextEditingController();

  var isListening = false;

  @override
  void initState() {
    super.initState();
    textEditingController.text = "Hold the button and start speaking or type here";
  }

  @override
  void dispose() {
    // コントローラーを破棄
    textEditingController.dispose();
    super.dispose();
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
        glowColor: Color.fromARGB(31, 12, 199, 15),
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          // タップを押し始めたときの処理
          onTapDown: (details) async {
            if (!isListening) {
              var available = await speechToText.initialize();
              if (available) {
                setState(() {
                  isListening = true;
                  speechToText.listen(onResult: (result) {
                    setState(() {
                      textEditingController.text = result.recognizedWords;
                    });
                  },
                  localeId: 'ja_JP',
                  );
                });
              }
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
              decoration: const InputDecoration(
                hintText: "Type something or use voice input",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {

                push(context);

              },
              child: const Text('設定を完了する'),
            ),
          ],
        ),
      ),
    );
  }
}

//  final textfield = TextField(
//       controller: _controller,
//       decoration: const InputDecoration(
//         hoverColor: Color.fromARGB(255, 250, 139, 139),
//         border: OutlineInputBorder(),
//         labelText: "プロフィールを入力してください",
//         hintText: '',
//         errorText: null,
//       ),
//     );

//     final n = ref.watch(createNotifierProvider.select((state) => state.name));
//     final a = ref.watch(createNotifierProvider.select((state) => state.age));
//     final i = ref.watch(createNotifierProvider.select((state) => state.image));
//     final p = ref.watch(createNotifierProvider.select((state) => state.profile));

//     final button = ElevatedButton(
//       onPressed: () async {
//         push(context);
//         final read = ref.read(createNotifierProvider.notifier);
//         read.updateProfile(controller.text);
//       },  
//       child: const Text("次へ>")
//       );

//     final create = FireDB();
//     create.create(n, a, i, p);



//     return Scaffold(
//      floatingActionButtonLocation:
//           FloatingActionButtonLocation.miniCenterFloat,
//       floatingActionButton: GestureDetector(
//           // タップを押し始めたときの処理
//           onTapDown: (details) async {
//             if (!isListening) {
//               var available = await speechToText.initialize();
//               debugPrint(available.toString());
//               if (available) {
//                 setState(() {
//                   isListening = true;
//                   speechToText.listen(onResult: (result) {
//                     setState(() {
//                       debugPrint("今だ！思いの丈をぶつけろ！！");
//                       text = result.recognizedWords;
//                       debugPrint(text.toString());
//                     });
//                   });
//                 });
//               }
//             }
//           },
//           onTapUp: (details) {
//             setState(() {
//               isListening = false;
//             });
//             speechToText.stop();
//           },
//           child: CircleAvatar(
//             backgroundColor: Colors.green,
//             radius: 35,
//             child: Icon(
//               isListening ? Icons.mic : Icons.mic_none,
//               color: Colors.white,
//             ),
//           ),
//         ),
//     body: Container(
//     decoration: const BoxDecoration(
//       image: DecorationImage(
//         image: AssetImage("assets/images/29117172S.jpg"), // ここに背景にしたい画像のパスを指定
//         fit: BoxFit.cover, // 画像がコンテナ全体にフィットするように調整
//       ),
//     ),
//     child: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             margin: const EdgeInsets.all(20),
//             width: 300,
//             child: textfield,
//           ),
//           button,
//           const SizedBox(
//             height: 100
//           ),
//           Text(text)
//         ],
//       ),
//     ),
//   ),
//     );









//スコープに関するエラーが発生しました次回からは気を付けよう！！