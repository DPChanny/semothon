import 'package:flutter/material.dart';

class TestResultPage extends StatelessWidget {
  final String result;

  const TestResultPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("test result")),
      body: Center(child: Text(result)),
    );
  }
}
