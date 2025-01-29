import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key,
    this.selectIndex = 0,
    this.height = 60,
    required this.dropdownItems,
    required this.onChanged,
  });

  final double height;
  final int? selectIndex;
  final List<DropdownMenuItem<int>>? dropdownItems;
  final Function(int?) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: (height - 20) / 2,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
      ),
      items: dropdownItems,
      onChanged: (selectIndex) => onChanged(selectIndex),
      value: selectIndex,
    );
  }
}
