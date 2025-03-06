import 'package:flutter/material.dart';

class CustomButtonn extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color textColor;
  final Color subtitleColor;

  const CustomButtonn({
    super.key,
    required this.onPressed,
    required this.backgroundColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.textColor = Colors.white,
    this.subtitleColor = Colors.white70,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: textColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(color: subtitleColor, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
