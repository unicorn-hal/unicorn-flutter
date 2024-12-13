import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class CustomTextfield extends StatefulWidget {
  /// heightの最小値は44
  const CustomTextfield({
    super.key,
    required this.hintText,
    this.backgroundcolor = Colors.white,
    this.textColor = ColorName.textBlack,
    required this.controller,
    this.prefixIcon,
    this.height = 60,
    this.maxLines = 3,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength = 300,
    required this.width,
    this.useSearchButton = false,
    this.buttonOnTap,
    this.onTapOutside,
  });

  final String hintText;
  final Color backgroundcolor;
  final Color textColor;
  final TextEditingController controller;
  final Icon? prefixIcon;
  final double height;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLength;
  final double width;
  final bool useSearchButton;
  final Function? buttonOnTap;
  final Function(PointerDownEvent)? onTapOutside;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: widget.useSearchButton ? widget.width * 0.85 : widget.width,
          child: TextFormField(
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            controller: widget.controller,
            onChanged: (value) {
              setState(() {});
            },
            onTapOutside: (PointerDownEvent event) {
              widget.onTapOutside?.call(event);
            },
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontFamily: 'Noto_Sans_JP',
              color: widget.textColor,
              fontSize: 16,
              height: 1.5,
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
                height: 1.5,
              ),
              filled: true,
              fillColor: widget.backgroundcolor,
              enabledBorder: OutlineInputBorder(
                borderRadius: widget.useSearchButton
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      )
                    : BorderRadius.circular(30),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: widget.useSearchButton
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      )
                    : BorderRadius.circular(30),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: (widget.height - 20) / 2,
                // (widget.height - (TextStyle(fontSize) * TextStyle(height))) / 2, + (textPadding or TextFormFieldMargin)
                horizontal: widget.prefixIcon != null ? 5 : 20,
              ),
            ),
            cursorColor: ColorName.mainColor,
            cursorWidth: 2,
            cursorRadius: const Radius.circular(10),
            maxLines: widget.useSearchButton ? 1 : widget.maxLines,
            minLines: 1,
            maxLength: widget.maxLength,
          ),
        ),
        Visibility(
          visible: widget.useSearchButton,
          child: GestureDetector(
            onTap: () => widget.buttonOnTap!(),
            child: Container(
              height: widget.height + 4,
              // (widget.height + 4 - 24) + (24 * 行数)
              // 行数が変動したタイミングとそのときの行数を持ってこれたら上の式に代入
              width: widget.width * 0.15,
              decoration: const BoxDecoration(
                color: ColorName.mainColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                border: Border(
                  top: BorderSide(
                    width: 1,
                    color: Colors.grey,
                  ),
                  right: BorderSide(
                    width: 1,
                    color: Colors.grey,
                  ),
                  bottom: BorderSide(
                    width: 1,
                    color: Colors.grey,
                  ),
                ),
              ),
              child: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
