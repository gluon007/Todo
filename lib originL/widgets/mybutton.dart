import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  // final void Function()? onPressed;
  const MyButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black, // Button background color
        foregroundColor: Colors.white, // Text color
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(text),
    );
    // return MaterialButton(
    //   onPressed: onPressed,
    //   color: Theme.of(context).primaryColor,
    //   child: const Text('text'),
    // );
  }
}
