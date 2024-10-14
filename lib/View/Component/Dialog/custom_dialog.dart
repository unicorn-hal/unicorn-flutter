import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog ({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(
          vertical: 270,
          horizontal: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              color: Colors.black,
              child: CustomText(
                text: 'title',
                color: Colors.white,
              )
            ),
            CustomText(text: 'テキストテキストテキストテキスト？？'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  text: 'キャンセル',
                  onTap: () {},
                  isFilledColor: false,
                  primaryColor: Colors.black,
                ),
                CustomButton(
                  text: '決定',
                  onTap: () {},
                  isFilledColor: true,
                  primaryColor: Colors.black,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class CustomDialog {
//   showCustomDialog({
//     required BuildContext context,
//     required String title,
//     required Widget content,
//     String logText = 'テキストテキストテキストテキスト？？', 
//     imgUrl = "",
//     String buttonText = '閉じる',
//     String rejectButtonText = 'キャンセル',
//     bool barrierDismissible = false,
//   }) {
//     showDialog(
//       context: context,
//       barrierColor: Colors.black.withOpacity(0.4),
//       barrierDismissible: barrierDismissible,
//       builder: (_) {
//         return Dialog(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(16.0),
//             ),
//           ),
//           insetPadding: const EdgeInsets.symmetric(
//             horizontal: 25,
//           ),
//           child: Container(
//             width: 160,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border(
//                 top: BorderSide(
//                   color: Colors.black, 
//                 ),
//               )
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 160,
//                   height: 50,
//                   padding: EdgeInsets.all(),
//                 )
//               ],
//             )
//           ),
//         ),
//       }
//     );
//   }
// }