import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/chatroom_done.dart';

class CreateChatRoomPage extends StatefulWidget {
  const CreateChatRoomPage({super.key});

  @override
  State<CreateChatRoomPage> createState() => _CreateChatRoomPageState();
}

class _CreateChatRoomPageState extends State<CreateChatRoomPage> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _maxController = TextEditingController();

  final _nameFocus = FocusNode();
  final _descFocus = FocusNode();
  final _maxFocus = FocusNode();

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateInput);
    _descController.addListener(_validateInput);
    _maxController.addListener(_validateInput);

    _nameFocus.addListener(() => setState(() {}));
    _descFocus.addListener(() => setState(() {}));
    _maxFocus.addListener(() => setState(() {}));
  }

  void _validateInput() {
    final name = _nameController.text.trim();
    final desc = _descController.text.trim();
    final max = int.tryParse(_maxController.text.trim());

    setState(() {
      _isButtonEnabled =
          name.isNotEmpty && desc.isNotEmpty && max != null && max > 0 && max <= 10;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _maxController.dispose();
    _nameFocus.dispose();
    _descFocus.dispose();
    _maxFocus.dispose();
    super.dispose();
  }

  void _handleNext() {
    // ✅ 다음 화면(RoomMakeDone)으로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RoomMakeDone(),
      ),
    );
  }

  Color _getFillColor(FocusNode node, TextEditingController controller) {
    // 포커스 중일 때 하늘색, 아니면 회색
    return node.hasFocus
        ? const Color(0xFFE6F0FA)
        : controller.text.isNotEmpty
            ? const Color(0xFFF5F5F5)
            : const Color(0xFFF5F5F5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("멘토 채팅방 개설", style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text("어떤 방인가요?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            const Text("방 이름", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              focusNode: _nameFocus,
              decoration: InputDecoration(
                hintText: "방 이름",
                border: OutlineInputBorder(borderSide: BorderSide.none),
                filled: true,
                fillColor: _getFillColor(_nameFocus, _nameController),
              ),
            ),
            const SizedBox(height: 20),

            const Text("방 소개", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              focusNode: _descFocus,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "어떤 방인지 알려주세요",
                border: OutlineInputBorder(borderSide: BorderSide.none),
                filled: true,
                fillColor: _getFillColor(_descFocus, _descController),
              ),
            ),
            const SizedBox(height: 20),

            const Text("최대 인원", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _maxController,
              focusNode: _maxFocus,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly], // ✅ 정수만
              decoration: InputDecoration(
                hintText: "몇 명이 들어올 수 있나요?",
                helperText: "최대 10명까지만 가능해요",
                border: OutlineInputBorder(borderSide: BorderSide.none),
                filled: true,
                fillColor: _getFillColor(_maxFocus, _maxController),
              ),
            ),
            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isButtonEnabled ? _handleNext : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008CFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("다음", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
