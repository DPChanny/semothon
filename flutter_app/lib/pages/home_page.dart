import 'package:flutter/material.dart';
import '../services/test_service.dart';
import 'test_result_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _goToResult(BuildContext context) async {
    final navigator = Navigator.of(context);
    final result = await TestService.test();

    navigator.push(
      MaterialPageRoute(builder: (_) => TestResultPage(result: result.result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("start test")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _goToResult(context),
          child: const Text("request test"),
        ),
      ),
    );
  }
}
