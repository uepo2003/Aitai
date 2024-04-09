import 'package:aitai/mains/message.dart';
import 'package:flutter/material.dart';

class ExportIcons extends StatelessWidget {
  final List<Message> icons;
  const ExportIcons({super.key, required this.icons});

  @override
  Widget build(BuildContext context) {
    final list = ListView.builder(
      scrollDirection: Axis.horizontal, // リストビューを横方向にスクロールさせる
      itemCount: icons.length,
      itemBuilder: (context, index) {
        // EdgeInsets margin = index == 0 ? const EdgeInsets.only(left: 25, right: 30) : const EdgeInsets.only(right: 30);
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              height: 80,
              width: 80,
              // alignment: Alignment.center,この記述がいらなかったみたい
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
             ),
             child: ClipOval(
               child: Image.network(
               icons[index].imageUrl,
               fit: BoxFit.cover,
                ),
               ),
            ),
            const SizedBox(
              width: 80,
              height: 15,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                ' 20歳 神奈川',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700
                ),
              )
              )
               ),
              ],
            );
          },
        );

    return Container(
      height: 95,
      color: Colors.white,
      child: list,
    );
  }
}
