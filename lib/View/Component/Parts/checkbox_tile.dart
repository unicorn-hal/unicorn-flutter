import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';

class CheckboxTile extends StatelessWidget {
  CheckboxTile({
    super.key,
    required this.checkboxText,
    required this.value,
    required this.onChanged,
    this.tileColor = Colors.blue,
  });
  final String checkboxText;
  final Function onChanged;
  bool value = false;
  final Color tileColor;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          onChanged.call();
        },
        child: Container(
          width: deviceWidth * 0.9,
          height: 70,
          decoration: BoxDecoration(
            color: value ? tileColor : Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 1,
              color: Colors.grey
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: value,
                onChanged: (value){
                  onChanged.call();
                },
              ),
              CustomText(
                color: value ? Colors.white : Colors.black,
                fontSize: 18,
                text: checkboxText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}