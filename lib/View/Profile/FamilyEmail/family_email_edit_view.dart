import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_textfield.dart';
import 'package:unicorn_flutter/View/Component/Parts/user_image_circle.dart';

class FamilyEmailEditView extends StatefulWidget {
  const FamilyEmailEditView({super.key});

  @override
  State<FamilyEmailEditView> createState() => _FamilyEmailEditViewState();
}

class _FamilyEmailEditViewState extends State<FamilyEmailEditView> {
  TextEditingController lastNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      width: deviceWidth,
      height: deviceHeight,
      child: Column(
        children: [
          UserImageCircle(
            imageSize: 150,
          ),
          Row(
            children: [
              CustomText(text: '姓'),
              CustomText(text: '名'),
            ],
          ),
          SizedBox(
            width: deviceWidth,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: deviceWidth * 0.4,
                  height: 60,
                  child: CustomTextfield(
                      hintText: 'のりた',
                      backgroundcolor: Colors.white,
                      controller: lastNameController),
                ),
                SizedBox(
                  width: deviceWidth * 0.4,
                  height: 60,
                  child: CustomTextfield(
                      hintText: 'しおき',
                      backgroundcolor: Colors.white,
                      controller: firstNameController),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
