import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    super.key,
    this.messageBody,
    required this.myMessage,
    required this.postAt,
    this.postAtColor,
    this.actionWidget,
    this.onLongPress,
  });

  final String? messageBody;
  final bool myMessage;
  final String postAt;
  final Widget? actionWidget;
  final Color? postAtColor;
  final Function? onLongPress;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onLongPress: () => onLongPress?.call(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment:
              myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            myMessage
                ? SizedBox(
                    width: 40,
                    height: 20,
                    child: Center(
                      child: CustomText(
                        text: postAt,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: postAtColor ?? Colors.white,
                      ),
                    ),
                  )
                : const SizedBox(
                    width: 10,
                  ),
            Container(
              decoration: BoxDecoration(
                color: myMessage
                    ? ColorName.messageColorOwn
                    : ColorName.messageColorOther,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                maxWidth: size.width * 0.7,
                minHeight: 30,
                minWidth: 30,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: actionWidget == null
                    ? CustomText(text: messageBody!)
                    : Column(
                        children: [
                          messageBody != null
                              ? CustomText(text: messageBody!)
                              : Container(),
                          actionWidget!,
                        ],
                      ),
              ),
            ),
            myMessage
                ? const SizedBox(
                    width: 10,
                  )
                : SizedBox(
                    width: 40,
                    height: 20,
                    child: Center(
                      child: CustomText(
                        text: postAt,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: postAtColor ?? Colors.white,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
