import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Controller/Profile/LocalAuth/local_auth_controller.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/spacer_and_divider.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/common_item_tile.dart';
import 'package:unicorn_flutter/View/Component/Parts/header_title.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class LocalAuthView extends StatefulWidget {
  const LocalAuthView({super.key, required this.from});
  final String from;

  @override
  State<LocalAuthView> createState() => _LocalAuthViewState();
}

class _LocalAuthViewState extends State<LocalAuthView> {
  late LocalAuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LocalAuthController(from: widget.from);
    _controller.loadUseLocalAuth((useLocalAuth) {
      setState(() {
        _controller.useLocalAuth = useLocalAuth;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        final bool authRes =
            await _controller.checkLocalAuth(context, _controller.useLocalAuth);
        if (!authRes) {
          return;
        }
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop(true);
      },
      child: CustomScaffold(
        isAppbar: _controller.useAppbar,
        appBar: _controller.useAppbar
            ? CustomAppBar(
                title: '生体認証',
                foregroundColor: Colors.white,
                backgroundColor: ColorName.mainColor,
              )
            : null,
        body: SafeArea(
          child: SizedBox(
            width: deviceWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: !_controller.useAppbar,
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: ColorName.textGray),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              CustomText(
                                text: 'Biometric Auth',
                                color: ColorName.profileInputBackgroundColor,
                                fontSize: 22,
                              ),
                              CustomText(
                                text: '生体認証でプライベートを守ります',
                                color: ColorName.textBlack,
                                fontSize: 22,
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                Visibility(
                  visible: _controller.useAppbar,
                  child: SizedBox(
                    width: deviceWidth,
                    child: const HeaderTitle(
                      title: 'セキュリティ',
                      useBorder: false,
                    ),
                  ),
                ),
                const SpacerAndDivider(
                  topHeight: 0,
                ),
                CommonItemTile(
                  title: '生体認証を使う',
                  action: _controller.useLocalAuth
                      ? const Icon(
                          Icons.check,
                          color: Colors.blue,
                        )
                      : null,
                  onTap: () {
                    _controller.updateUseLocalAuth(true, (value) {
                      setState(() {
                        _controller.useLocalAuth = value;
                      });
                    });
                  },
                ),
                const SpacerAndDivider(),
                CommonItemTile(
                  title: '設定しない',
                  action: !_controller.useLocalAuth
                      ? const Icon(
                          Icons.check,
                          color: Colors.blue,
                        )
                      : null,
                  onTap: () {
                    _controller.updateUseLocalAuth(false, (value) {
                      setState(() {
                        _controller.useLocalAuth = value;
                      });
                    });
                  },
                ),
                const SpacerAndDivider(),
                Visibility(
                  visible: !_controller.useAppbar,
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: SizedBox(
                        width: deviceWidth * 0.5,
                        height: 60,
                        child: CustomButton(
                          fontSize: 18,
                          isFilledColor: true,
                          text: '設定',
                          onTap: () async {
                            final bool authRes =
                                await _controller.checkLocalAuth(
                                    context, _controller.useLocalAuth);
                            if (!authRes) {
                              return;
                            }
                            // ignore: use_build_context_synchronously
                            const HomeRoute().go(context);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
