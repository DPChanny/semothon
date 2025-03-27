import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget bottomNavigationBarWidget() {
    return BottomNavigationBar(
      items:[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: '홈',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.chat),
        label: '채팅',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.school),
        label: '공모전',
      ),
    ],);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HOME")),
      body: Center(
      ),
      bottomNavigationBar: bottomNavigationBarWidget(),
    );
  }
}
