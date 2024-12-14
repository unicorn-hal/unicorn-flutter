import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Controller/Home/home_controller.dart';
import 'package:unicorn_flutter/Controller/bottom_navigation_bar_controller.dart';
import 'package:unicorn_flutter/Model/Cache/Medicine/medicine_cache.dart';
import 'package:unicorn_flutter/Model/Entity/Call/call_standby.dart';
import 'package:unicorn_flutter/Model/Entity/Hospital/hospital_news.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/medicine.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_dialog.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_indicator.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/spacer_and_divider.dart';
import 'package:unicorn_flutter/View/Component/Parts/Home/board_tile.dart';
import 'package:unicorn_flutter/View/Component/Parts/Home/medicine_limit_card.dart';
import 'package:unicorn_flutter/View/Component/Parts/Home/receive_call_cell.dart';
import 'package:unicorn_flutter/View/Component/Parts/health_check_button.dart';
import 'package:unicorn_flutter/View/Component/Parts/register_content_tile.dart';
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
                Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: CustomText(
                        text: _controller.today,
                        fontSize: 20,
                      ),
                    ),
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: ReceiveCallCell(
                        onTap: () => _controller.goVideoCall(),
                        doctorName: value.doctorName,
                        hospitalName: value.hospitalName,
                        reservationDateTimes: value.reservationDateTimes,
                      ),
                    );
                  },
                ),
                Consumer(builder: (context, ref, _) {
                  final medicineCacheRef = ref.watch(medicineCacheProvider);

                  if (medicineCacheRef.data.isEmpty) {
                    // todo: おくすりが登録されていない場合のView
                    return RegisterContentTile(
                      tileText: 'おくすりを登録する',
                      onTap: () {
                        const HomeMedicineSettingRoute().push(context);
                      },
                    );
                  }
                  return Column(
                    children: [
                      CarouselSlider.builder(
                        carouselController: medicineCacheRef.carouselController,
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
                                if (medicineCacheRef.carouselIndex == index) {
                                  return;
                                }
                                medicineCacheRef.setCarouselIndex(index);
                                medicineCacheRef.carouselController
                                    .animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: MedicineLimitCard(
                                medicine: medicine,
                                color: _controller.getColor(index),
                                submitOnTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      final int remainingMedicine =
                                          medicine.quantity - medicine.dosage;
                                      return CustomDialog(
                                        title: 'おくすりを服用します',
                                        bodyText:
                                            '${medicine.medicineName} を服用しますか？\n${remainingMedicine < 0 ? '残りすべてのおくすりが消費されます。' : '残りは $remainingMedicine錠 です。'}',
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
                                editOnTap: () {
                                  HomeMedicineSettingRoute(
                                    $extra: medicine,
                                  ).push(context);
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
                            medicineCacheRef.setCarouselIndex(index);
                          },
                        ),
                      ),
                      DotsIndicator(
                        dotsCount: medicineCacheRef.data.length,
                        position: medicineCacheRef.carouselIndex,
                        decorator: const DotsDecorator(
                          color: Colors.grey,
                          activeColor: ColorName.mainColor,
                        ),
                        onTap: (position) {
                          medicineCacheRef.setCarouselIndex(position);
                          medicineCacheRef.carouselController.animateToPage(
                            position,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
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
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 10, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      text: 'お知らせ・掲示板',
                      fontSize: 20,
                    ),
                    IconButton(
                      onPressed: () async {
                        await _controller.getHospitalNews(reload: true);
                        setState(() {});
                      },
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ),
          FutureBuilder(
            future: _controller.getHospitalNews(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox(
                  height: 200,
                  child: Center(
                    child: CustomIndicator(),
                  ),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: SizedBox(
                    height: 200,
                    child: CustomText(text: 'お知らせの取得に失敗しました'),
                  ),
                );
              }
              if (snapshot.data == null) {
                return const Center(
                  child: SizedBox(
                    height: 200,
                    child: CustomText(text: 'お知らせはありません'),
                  ),
                );
              }

              List<HospitalNews> hospitalNewsList =
                  snapshot.data as List<HospitalNews>;

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: hospitalNewsList.length,
                itemBuilder: (BuildContext context, int index) {
                  final HospitalNews hospitalNews = hospitalNewsList[index];
                  return SizedBox(
                    child: BoardTile(
                      title: hospitalNews.title,
                      subtitle:
                          '${DateFormat('yyyy/MM/dd HH:mm').format(hospitalNews.postedDate.toLocal())} - ${hospitalNews.hospitalName}',
                      content: hospitalNews.content,
                      imageUrl: hospitalNews.imageUrl,
                      onTap: () =>
                          _controller.launchUrl(hospitalNews.relatedUrl),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
