import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class CustomTextfield extends StatefulWidget {
  /// heightの最小値は44
  const CustomTextfield({
    super.key,
    required this.hintText,
    this.backgroundcolor = Colors.white,
    required this.controller,
    this.prefixIcon,
    this.height = 60,
    this.maxLines = 3,
    this.number = false,
  });

  final String hintText;
  final Color backgroundcolor;
  final TextEditingController controller;
  final Icon? prefixIcon;
  final double height;
  final int maxLines;
  final bool number;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.number ? TextInputType.number : null,
      inputFormatters:
          widget.number ? [FilteringTextInputFormatter.digitsOnly] : null,
      controller: widget.controller,
      onChanged: (value) {
        setState(() {});
      },
      textAlignVertical: TextAlignVertical.center,
      style: const TextStyle(
        decorationColor: ColorName.mainColor,
      ),
      decoration: InputDecoration(
        counterText: '',
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
          vertical: (widget.height - 20) / 2,
          horizontal: widget.prefixIcon != null ? 5 : 20,
        ),
      ),
      cursorColor: ColorName.mainColor,
      cursorWidth: 2,
      cursorRadius: const Radius.circular(10),
      maxLines: widget.maxLines,
      minLines: 1,
      maxLength: 300,
    );
  }
}
