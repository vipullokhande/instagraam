import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  const DialogButton({Key? key, required this.icon, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.black,
              size: 70,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
