import 'package:flutter/material.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({
    super.key,
    required this.hintText,
    required this.backgroundcolor,
    required this.controller,
    this.prefixIcon,
  });

  final String hintText;
  final Color backgroundcolor;
  final TextEditingController controller;
  final Icon? prefixIcon;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: (value) {
        setState(() {});
      },
      textAlignVertical: TextAlignVertical.center,
      style: const TextStyle(
        decorationColor: ColorName.mainColor,
      ),
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        suffixIcon: Visibility(
          visible: widget.controller.text.isNotEmpty,
          child: IconButton(
            icon: const Icon(
              Icons.cancel_rounded,
              color: Colors.grey,
            ),
            onPressed: () {
              widget.controller.text = '';
              setState(() {});
            },
          ),
        ),
        border: InputBorder.none,
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          decoration: TextDecoration.none,
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Noto_Sans_JP',
        ),
        filled: true,
        fillColor: widget.backgroundcolor,
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
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: widget.prefixIcon != null ? 5 : 30,
        ),
      ),
      cursorColor: ColorName.mainColor,
      cursorWidth: 2,
      cursorRadius: const Radius.circular(10),
    );
  }
}
