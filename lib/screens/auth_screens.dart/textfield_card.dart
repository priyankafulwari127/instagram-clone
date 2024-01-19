import 'package:flutter/material.dart';

class TextFieldCard extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final bool isPass;
  final TextInputType textInputType;

  const TextFieldCard(
      {super.key,
      required this.textEditingController,
      required this.hintText,
      this.isPass = false,
      required this.textInputType});

  @override
  Widget build(BuildContext context) {
    final InputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    return TextField(
      controller: textEditingController,
      keyboardType: textInputType,
      obscureText: isPass,
      decoration: InputDecoration(
        hintText: hintText,
        border: InputBorder,
        focusedBorder: InputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
    );
  }
}
