import 'package:flutter/material.dart';
import 'package:instagraam/resources/dark_mode.dart';
import 'package:provider/provider.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final bool isPass;
  final TextInputType textInputType;
  const TextInputField({
    Key? key,
    required this.textEditingController,
    required this.hintText,
    this.isPass = false,
    required this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkMode>(context).isDark;

    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      autofocus: false,
      controller: textEditingController,
      obscureText: isPass,
      keyboardType: textInputType,
      decoration: InputDecoration(
        border: inputBorder,
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDark
              ?const Color.fromARGB(255, 0, 0, 0)
              :const Color.fromARGB(255, 255, 255, 255),
        ),
        filled: true,
        fillColor: isDark
            ?const Color.fromARGB(255, 255, 255, 255)
            :const Color.fromARGB(255, 86, 86, 86),
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        contentPadding: const EdgeInsets.all(8.0),
      ),
    );
  }
}
