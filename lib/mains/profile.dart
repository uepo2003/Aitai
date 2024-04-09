//プロフィール画面
import 'package:aitai/providers/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final percentProvider = StateProvider((ref) {
  return 0.0;
});

class Menu extends StatelessWidget {
  final String name;
  const Menu({super.key, required this.name});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      color: Colors.blue,
      alignment: Alignment.center,
      child: Text(name, style: const TextStyle(color: Colors.white)),
    );
  }
}

class Anything extends StatelessWidget {
  final IconData iconData; 
  final String text;
  const Anything({
    super.key,
    required this.iconData,
    required this.text
    });

  @override
  Widget build(BuildContext context) {
    
    final aikon = Container(
        height: 50,
        width: 50,
        margin: const EdgeInsets.only(left: 10),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.transparent),
        child: Align(
                alignment: const Alignment(0, 0),
                child: Icon(iconData),
              ),
      );

      //変数を定数で囲ってしまったためエラーが発生しました次からは気をつけよう！！
    
    final sutetasu = Container(
      height: 50,
      width: 150,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Align(
        alignment: const Alignment(-1,-0.1),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
           
          ),),
        )
    );
    return Material(
      color: Colors.transparent, //この設定はなんの意味があるんだろう？
      child: InkWell(
        onTap: () {
          debugPrint("コンテナをボタン化することに成功しました！");
        },
        child: Ink(
          height: 50,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
             aikon,
             sutetasu
              ],
          ),
        ),
      ),
    );
  }
}

class PromoCard extends StatelessWidget {
  // final String image;
  final int number;
  const PromoCard({super.key, required this.number
      //  required this.image
      });
  @override
  Widget build(BuildContext context) {
    if (number == 0) {
      return Container(
        height: 90,
        width: 190,
        margin: const EdgeInsets.only(left: 20, right: 20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("assets/images/29117172S.jpg"), // ここに背景にしたい画像のパスを指定
            fit: BoxFit.cover, // 画像がコンテナ全体にフィットするように調整
          ),
        ),
      );
    } else {
      return Container(
        height: 90,
        width: 190,
        margin: const EdgeInsets.only(right: 20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("assets/images/29117172S.jpg"), // ここに背景にしたい画像のパスを指定
            fit: BoxFit.cover, // 画像がコンテナ全体にフィットするように調整
          ),
        ),
      );
    }
  }
}


class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => ProfileState();
}

class ProfileState extends ConsumerState<Profile> {

 String? url = "";
  @override
  void initState() {
    super.initState();
    // `initState`ではlistenだけを行い、`ref.watch`は`build`で使う。これ大事！！
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final c = ref.read(currentUserProvider);
      imageRead(c);
    });
  }

  Future<void> imageRead(String? cu) async {
  final db = FirebaseFirestore.instance;
  final sn = await db.collection("users").doc(cu).get();
  final im = sn.get("image");
 setState(() {
   url = im;
 });

}
  @override
  Widget build(BuildContext context) {
    final mainIcon = Container(
      padding: const EdgeInsets.only(top: 20),
      height: 150,
      width: 200,
      color: Colors.white,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.network(
                  url.toString(), // TwitterアイコンのURLを指定
                  fit: BoxFit.cover, // 画像がコンテナにぴったり合うように調整
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.4, 0.6),
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color.fromARGB(255, 232, 148, 203)),
              child: const Icon(Icons.home, color: Colors.white,),
            ),
          ),
        ],
      ),
    );

    final goodCount = Container(
        height: 30,
        width: 60,
        margin: const EdgeInsets.only(left: 20),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color.fromARGB(203, 235, 231, 231)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.headphones),
            Text(
              '467',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            )
          ],
        ));

    final coinButton = Container(
        height: 30,
        width: 40,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color:Color.fromARGB(203, 235, 231, 231)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.money),
            Text(
              '5',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            )
          ],
        ));

    final storeButton = Container(
        height: 30,
        width: 150,
        margin: const EdgeInsets.only(right: 20),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color:  Color.fromARGB(203, 235, 231, 231)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.shop_2),
            Text(
              'ペアーズストア',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            )
          ],
        ));

    final status = Container(
      height: 50,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [goodCount, coinButton, storeButton],
      ),
    );

    final kaiinIcon = Container(
        height: 50,
        width: 50,
        margin: const EdgeInsets.only(left: 10),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.transparent),
        child: const Align(
                alignment: Alignment(0, 0),
                child: Icon(Icons.shop_2),
              ),
      );
      

    final kaiinStatus = Container(
      height: 50,
      width: 150,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: const Align(
        alignment: Alignment(-1,-0.1),
        child: Text(
          '会員ステータス',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
           
          ),),
        )
    );
    final premiumKaiin = Container(
        height: 50,
        width: 160,
        margin: const EdgeInsets.only(right: 20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: const Align(
            alignment: Alignment(0.8, 0),
            child: Text(
              'プレミアム会員 >',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            )
        )
        );

    final con2 = Material(
      color: Colors.transparent, //この設定はなんの意味があるんだろう？
      child: InkWell(
        onTap: () {
          debugPrint("コンテナをボタン化することに成功しました！");
        },
        child: Ink(
          height: 50,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              kaiinIcon,
              kaiinStatus, 
              premiumKaiin
              ],
          ),
        ),
      ),
    );

    final premiumAnnouncement = Stack(
      children: <Widget>[
        Container(height: 80, color: Colors.white),
        Positioned(
          left: 10,
          top: 15,
          child: SizedBox(
            width: 370, //横幅
            height: 47, //高さ
            child: ElevatedButton(
              onPressed: () {},
              style:  ButtonStyle(
                backgroundColor:  MaterialStateProperty.all(
                   const Color.fromARGB(255, 221, 208, 21)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // ボーダーラジアスを設定
                  ),
                ),
              ),
              child: const Text(
                'プレミアムなら豊富な機能でサポート',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ),
      ],
    );

    final slider = Container(
      margin: const  EdgeInsets.only(bottom: 10),
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 100, // アイテムの総数
        itemBuilder: (BuildContext context, int index) {
          final card = PromoCard(number: index);
          return card;
        },
      ),
    );

    final c1 = Container(
        height: 25,
        width: 229,
        margin: const EdgeInsets.only(left: 10),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              size: 23,
            ),
            SizedBox(width: 8),
            Text(
              '無料でいいね！を送ろう！',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ));

    final c2 = Container(
     margin: const EdgeInsets.only(right: 15),
     child: Material(
      color: Colors.transparent,
      child: Ink(
       width: 120,
       height: 34,
       decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: const Color.fromARGB(255, 231, 226, 223), width: 1.5),
       ),
         child: InkWell(
          onTap: () {
            debugPrint("成功");
          },
          borderRadius: const BorderRadius.all(Radius.circular(20)), // InkWellのリップルエフェクトの範囲をInkのborderRadiusに合わせる
           child: Container(
           alignment: const Alignment(0, -0.6), //子供がセンターになる
           child: const Text(
            '使ってみる',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
             ),
            ),
          ),
        ),
       ),
      );


    final freeContainer = Container(
      height: 50,
      color: Colors.orange,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          c1,
          c2
        ],
      ),
    );

    final con3 = Column(
      children: [con2, premiumAnnouncement],
    );

    final con4 = Expanded(
      child: ListView(
        children: const [
         Anything(iconData: Icons.home, text: 'ホーム'),
         Anything(iconData: Icons.handshake, text: 'お互い気になる!'),
         Anything(iconData: Icons.star, text: 'お気に入り'),
         Anything(iconData: Icons.safety_check, text: 'セーフティセンター'),
         Anything(iconData: Icons.view_column, text: 'コラム'),
          // 必要なだけMenuウィジェットを追加できます。
        ],
      ),
    );

    return Scaffold(
        body: Column(
      children: [
        mainIcon,
        status,
        const Divider(
          color: Color.fromARGB(255, 196, 175, 174),
          height: 0,
          thickness: 3,
        ),
        con3,
        slider,
        freeContainer,
        con4
      ],
    ));
  }
}


