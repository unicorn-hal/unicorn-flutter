import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    super.key,
    required this.messageBody,
    required this.myMessage,
    required this.postAt,
  });

  final String messageBody;
  final bool myMessage;
  final String postAt;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
                      color: Colors.white,
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
              maxWidth: size.width * 0.6,
              minHeight: 30,
              minWidth: 30,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomText(text: messageBody),
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
                      color: Colors.white,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
