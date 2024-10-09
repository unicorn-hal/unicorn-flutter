import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/Parts/Home/board_tile.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BoardTile(
                title: '検診受付時間の変更', content: '2021年10月10日より検診受付時間が変更になります。'),
            SizedBox(height: 10),
            BoardTile(
                title: '定期検診のお知らせ',
                content:
                    '2021年10月10日に定期検診を行います。2021年10月10日に定期検診を行います。2021年10月10日に定期検診を行います。2021年10月10日に定期検診を行います。あsdオフィhソフィはs歩ひlkjおdsjg＠dそいgじゃ＠sdfいじょdfbsdpbjsdbpjdfじゃs＠fkじゃ＠おfkj亜s＠fじゃ＠kfjsdkfじゃs：lfkj：'),
            SizedBox(height: 10),
            BoardTile(
                imageUrl:
                    'https://www.anpanman.jp/assets/images/common/OGP.png',
                title: '定期検診のお知らせ',
                content:
                    '2021年10月10日に定期検診を行いまに定期検診を行います。2021年10月10日に定期検診を行います。2021年10月10日に定期検診を行いま'),
            SizedBox(height: 10),
            BoardTile(
              imageUrl: 'https://www.anpanman.jp/assets/images/common/OGP.pn',
              title: '定期検診のお知らせ',
              content: '2021年10月10日に定期検診を行います。',
            ),
          ],
        ),
      ),
    );
  }
}
