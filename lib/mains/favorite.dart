import 'package:aitai/widgets/dialog.dart';
import 'package:flutter/material.dart';

//いいね画面
class Favorite extends StatelessWidget {
  const Favorite({super.key});

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
              fontSize: 16,
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
