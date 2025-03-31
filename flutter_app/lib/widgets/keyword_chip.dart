import 'package:flutter/material.dart';

class KeywordChip extends StatelessWidget {
  final String text;

  const KeywordChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white, // 💡 글자색 확실하게 지정!
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
