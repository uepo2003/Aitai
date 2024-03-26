import 'package:flutter/material.dart';

class MatchingIcon {
  final String iconUrl;
  final String age;
  final String region;

  MatchingIcon(this.iconUrl, this.age, this.region);
}

final matchingIcons = [
  MatchingIcon("https://example.com/icon1.png", "25", "Tokyo"),
  MatchingIcon("https://example.com/icon2.png", "30", "Osaka"),
  MatchingIcon("https://example.com/icon3.png", "28", "Kyoto"),
  MatchingIcon("https://example.com/icon4.png", "22", "Hokkaido"),
  MatchingIcon("https://example.com/icon5.png", "27", "Fukuoka"),
  MatchingIcon("https://example.com/icon6.png", "29", "Nagoya"),
  MatchingIcon("https://example.com/icon7.png", "26", "Okinawa"),
  MatchingIcon("https://example.com/icon8.png", "31", "Kobe"),
  MatchingIcon("https://example.com/icon9.png", "24", "Yokohama"),
  MatchingIcon("https://example.com/icon10.png", "32", "Sapporo"),
];


class ExportIcons extends StatelessWidget {
  const ExportIcons({super.key});

  @override
  Widget build(BuildContext context) {
    final list = ListView.builder(
      scrollDirection: Axis.horizontal, // リストビューを横方向にスクロールさせる
      itemCount: matchingIcons.length,
      itemBuilder: (context, index) {
        EdgeInsets margin = index == 0 ? const EdgeInsets.only(left: 25, right: 30, top:15) : const EdgeInsets.only(right: 30, top:15);
        return Container (
          margin: margin,
          child: Stack(
          children: <Widget>[
            Container(
              height: 70,
              width: 70,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
             // ここでのデコレーションを追加してください
             ),
           child: ClipOval(
               child: Image.asset(
               'assets/images/myedit_ai_image02.jpg',
               fit: BoxFit.cover,
                ),
               ),
            ),
            Positioned(
              bottom: 17,
              child: Container(
              width: 80,
              height: 15,
              child: Text(
                ' 20歳 神奈川',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900
                ),
              )
               ),
               ),
              ],
            ),
           );
          },
        );

    return Container(
      height: 120,
      color: Colors.white,
      child: list,
    );
  }
}
