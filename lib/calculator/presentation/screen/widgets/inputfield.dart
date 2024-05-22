import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      canRequestFocus: true,
      readOnly: true,
      showCursor: true,
      controller: controller,
      textAlign: TextAlign.end,
      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 40),
      decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          fillColor: Colors.grey[200],
          // suffixIcon: const SizedBox(
          //   height: 50,
          //   width: 80,
          //   child: CalcBackButton(),
          // ),
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none),
    );
  }
}
