import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicorn_flutter/Controller/Home/home_controller.dart';
import 'package:unicorn_flutter/Controller/bottom_navigation_bar_controller.dart';
import 'package:unicorn_flutter/Model/Cache/Medicine/medicine_cache.dart';
import 'package:unicorn_flutter/Model/Entity/Call/call_standby.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/medicine.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_dialog.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/spacer_and_divider.dart';
import 'package:unicorn_flutter/View/Component/Parts/Home/board_tile.dart';
import 'package:unicorn_flutter/View/Component/Parts/Home/medicine_limit_card.dart';
import 'package:unicorn_flutter/View/Component/Parts/health_check_button.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomeController(context);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;

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
                  bottomHeight: 0,
                ),
                ValueListenableBuilder(
                  valueListenable: _controller.callStandbyNotifier,
                  builder: (BuildContext context, CallStandby? value,
                      Widget? child) {
                    if (value == null) {
                      return Container();
                    }
                    return GestureDetector(
                      onTap: () => _controller.goVideoCall(),
                      child: Container(
                        height: 100,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.call, color: Colors.green),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 5,
                                    left: 10,
                                    right: 10,
                                  ),
                                  child: CustomText(
                                    text: '通話の準備ができました',
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      text: '${value.doctorName}先生',
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    const SizedBox(width: 5),
                                    CustomText(
                                      text: '(${value.hospitalName})',
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                                CustomText(
                                  text: value.reservationDateTimes,
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Consumer(builder: (context, ref, _) {
                  final medicineCacheRef = ref.watch(medicineCacheProvider);

                  if (medicineCacheRef.data.isEmpty) {
                    // todo: おくすりが登録されていない場合のView
                    return DottedBorder(
                      dashPattern: const [15, 10],
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(20),
                      child: SizedBox(
                        width: deviceWidth * 0.9,
                        height: 200,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.grey,
                              size: 22,
                            ),
                            CustomText(
                              text: 'おくすりを登録する',
                              color: ColorName.textGray,
                              fontSize: 14,
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      CarouselSlider.builder(
                        carouselController: _controller.carouselController,
                        itemCount: medicineCacheRef.data.length,
                        itemBuilder: (
                          BuildContext context,
                          int index,
                          int realIndex,
                        ) {
                          Medicine medicine = medicineCacheRef.data[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: GestureDetector(
                              onTap: () {
                                if (_controller.carouselIndex == index) return;
                                _controller.carouselIndex = index;
                                _controller.carouselController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                                setState(() {});
                              },
                              child: MedicineLimitCard(
                                medicine: medicine,
                                color: _controller.colors[index % 10],
                                buttonOnTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      final int remainingMedicine =
                                          medicine.quantity - medicine.dosage;
                                      return CustomDialog(
                                        title: 'おくすりを服用します',
                                        bodyText:
                                            '${medicine.medicineName}を ${medicine.dosage}錠 服用しますか？\n${remainingMedicine < 0 ? '残りのすべてのおくすりが服用されます。' : '残りは $remainingMedicine錠 です。'}',
                                        rightButtonOnTap: () async {
                                          ProtectorNotifier().enableProtector();
                                          await _controller
                                              .takeMedicine(medicine);
                                          ProtectorNotifier()
                                              .disableProtector();
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 400,
                          initialPage: 0,
                          autoPlay: false,
                          viewportFraction: 0.8,
                          enableInfiniteScroll: false,
                          onPageChanged: (index, _) {
                            _controller.carouselIndex = index;
                            setState(() {});
                          },
                        ),
                      ),
                      DotsIndicator(
                        dotsCount: medicineCacheRef.data.length,
                        position: _controller.carouselIndex,
                        decorator: const DotsDecorator(
                          color: Colors.grey,
                          activeColor: ColorName.mainColor,
                        ),
                        onTap: (position) {
                          _controller.carouselIndex = position;
                          _controller.carouselController.animateToPage(
                            position,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                          setState(() {});
                        },
                      ),
                    ],
                  );
                }),
                const SizedBox(
                  height: 10,
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
            itemCount: _controller.boardList.length,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                child: BoardTile(
                  title: _controller.boardList[index]['title'],
                  content: _controller.boardList[index]['content'],
                  imageUrl: _controller.boardList[index]['imageUrl'],
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
