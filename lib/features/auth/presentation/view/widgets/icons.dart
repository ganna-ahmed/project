import 'package:flutter/material.dart';

class BackIconWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const BackIconWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: onPressed,
    );
  }
}
