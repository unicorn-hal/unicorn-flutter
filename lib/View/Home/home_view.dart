import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Controller/bottom_navigation_bar_controller.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/spacer_and_divider.dart';
import 'package:unicorn_flutter/View/Component/Parts/Home/board_tile.dart';
import 'package:unicorn_flutter/View/Component/Parts/Home/medicine_limit_card.dart';
import 'package:unicorn_flutter/View/Component/Parts/health_check_button.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // todo: 変数はすべてControllerから取得する
  final List<Map<String, dynamic>> boardList = [
    {
      'title': 'タイトル1',
      'content': '内容1',
      'imageUrl': 'https://picsum.photos/200/300',
    },
    {
      'title': 'タイトル2',
      'content': '内容2',
      'imageUrl': 'https://picsum.photos/200/300',
    },
    {
      'title': 'タイトル3',
      'content': '内容3',
      'imageUrl': 'https://picsum.photos/200/300',
    },
  ];

  final List<Map<String, dynamic>> medicineList = [
    {
      'name': 'カロナール',
      'remainingDays': 7,
      'remainingCount': 7,
      'progressColor': Colors.green,
      'currentNum': 2,
      'totalNum': 14,
    },
    {
      'name': 'アポトキシン4869',
      'remainingDays': 5,
      'remainingCount': 30,
      'progressColor': Colors.red,
      'currentNum': 8,
      'totalNum': 25,
    },
  ];

  int _currentIndex = 0;
  CarouselSliderController carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;

    return CustomScaffold(
      isScrollable: true,
      appBar: CustomAppBar(
        backgroundColor: ColorName.mainColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              // todo: 新規通知がある場合の処理
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: deviceHeight * 0.45,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: CustomText(text: '10月25日金曜日'),
                    // todo: 現在の日付を取得する
                  ),
                ),
                const SpacerAndDivider(
                  topHeight: 0,
                  bottomHeight: 10,
                ),
                CarouselSlider.builder(
                  carouselController: carouselController,
                  itemCount: medicineList.length,
                  itemBuilder: (
                    BuildContext context,
                    int index,
                    int realIndex,
                  ) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: GestureDetector(
                        onTap: () {
                          if (_currentIndex == index) return;
                          _currentIndex = index;
                          carouselController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                          setState(() {});
                        },
                        child: MedicineLimitCard(
                          medicineName: medicineList[index]['name'],
                          remainingDays: medicineList[index]['remainingDays'],
                          remainingCount: medicineList[index]['remainingCount'],
                          progressColor: medicineList[index]['progressColor'],
                          currentNum: medicineList[index]['currentNum'],
                          totalNum: medicineList[index]['totalNum'],
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 160,
                    initialPage: 0,
                    autoPlay: false,
                    viewportFraction: 0.8,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, _) {
                      _currentIndex = index;
                      setState(() {});
                    },
                  ),
                ),
                DotsIndicator(
                  dotsCount: medicineList.length,
                  position: _currentIndex,
                  decorator: const DotsDecorator(
                    color: Colors.grey,
                    activeColor: ColorName.mainColor,
                  ),
                  onTap: (position) {
                    _currentIndex = position;
                    carouselController.animateToPage(
                      position,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                    setState(() {});
                  },
                ),
                HealthCheckButton(
                  onTap: () => BottomNavigationBarController().goBranch(1),
                ),
              ],
            ),
          ),
          const SpacerAndDivider(
            topHeight: 10,
            bottomHeight: 0,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20, top: 10, bottom: 20),
              child: CustomText(text: 'お知らせ・掲示板'),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: boardList.length,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                child: BoardTile(
                  title: boardList[index]['title'],
                  content: boardList[index]['content'],
                  imageUrl: boardList[index]['imageUrl'],
                  onTap: () {
                    // todo: タップ時の処理
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
