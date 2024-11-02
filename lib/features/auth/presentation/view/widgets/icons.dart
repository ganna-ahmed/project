import 'package:flutter/material.dart';

class BackIconWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const BackIconWidget({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: onPressed,
    );
  }
}
