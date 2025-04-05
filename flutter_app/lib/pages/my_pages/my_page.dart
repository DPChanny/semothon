import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/routes/login_page_routes.dart';
import 'package:flutter_app/routes/main_page_routes.dart';
import 'package:flutter_app/routes/mentoring_tab_routes.dart';
import 'package:flutter_app/routes/my_page_routes.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/dto/user_info_dto.dart';
import 'package:flutter_app/services/queries/user_query.dart';
import 'package:flutter_app/dto/chat_room_info_dto.dart';
import 'package:flutter_app/services/queries/crawling_query.dart';

Future<bool> isCurrentUserHost() async {
  final result = await getUser();
  if (!result.success || result.user == null) return false;
  return result.user!.isHost();
}

class MyPage extends StatefulWidget {
  final UserInfoDto user;
  final List<ChatRoomInfoDto> chatRooms;

  const MyPage({super.key, required this.user, required this.chatRooms});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  bool? _isHost;

  @override
  void initState() {
    super.initState();
    _checkHostStatus();
  }

  Future<void> _checkHostStatus() async {
    final hostStatus = await isCurrentUserHost();
    setState(() {
      _isHost = hostStatus;
    });
  }

  String _formatBirthdate(DateTime? birthdate) {
    if (birthdate == null) return '';
    return DateFormat('yyyyMMdd').format(birthdate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 하단 흰 배경
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('마이페이지', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(height: 150, color: Colors.blue),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 60),
                      padding: const EdgeInsets.only(top: 20, bottom: 60),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 70),
                          // 닉네임
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.user.nickname ?? '닉네임 없음',
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blue),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${widget.user.name ?? ''} (${widget.user.gender ?? ''})',
                                      style: TextStyle(fontSize: 10, color: Colors.grey[700])),
                                  Text(_formatBirthdate(widget.user.birthdate),
                                      style: TextStyle(fontSize: 10, color: Colors.grey[700])),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.user.department ?? '',
                                      style: TextStyle(fontSize: 10, color: Colors.grey[700])),
                                  Text(widget.user.studentId ?? '',
                                      style: TextStyle(fontSize: 10, color: Colors.grey[700])),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // 관심 분야
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Text('나의 관심분야', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, MyPageRouteNames.myInterestPage);
                                  },
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.user.interests.map((interest) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.blue[600],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  interest,
                                  style: const TextStyle(fontSize: 10, color: Colors.white),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 40),

                          // 멘토/비멘토 영역
                          if (_isHost == null)
                            const CircularProgressIndicator()
                          else if (_isHost!)
                            _buildMentorSection(widget.chatRooms)
                          else
                            _buildBecomeMentorSection(),

                          const SizedBox(height: 20),

                          _buildActivitySection(context)
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(widget.user.profileImageUrl),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.grey[200],
                              child: const Icon(Icons.camera_alt, size: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBecomeMentorSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundColor: Color(0xffe8f0fe),
            child: Text("🙆‍♂️", style: TextStyle(fontSize: 30)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("지금 바로 멘토가 되어 보세요",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Text("누구나 멘토가 될 수 있어요",
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, MyMentorTabRouteNames.shortIntroInputPage);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 20)),
                  child: const Text("나도 멘토 되기", style: TextStyle(color: Colors.white),),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentorSection(List<ChatRoomInfoDto> chatRooms) {
    final mentorIntro = chatRooms.isNotEmpty ? chatRooms.first.description : '멘토 소개글이 없습니다.';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("My 멘토", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, MainPageRouteNames.mainPage, arguments: 2);
                },
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text("멘토 소개글", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          
          Text("“$mentorIntro”", style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 15),
          const Text("멘토방", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        
          ...chatRooms.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final room = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Text(index.toString().padLeft(2, '0'),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Text(room.title, style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 8),
                  const Icon(Icons.group, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text("${room.currentMemberCount}/${room.capacity}",
                      style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}



Widget _buildActivitySection(BuildContext context) {
  return FutureBuilder(
    future: getCrawlingList(limit: 4), // 예: 최근 4개만 가져오기
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const CircularProgressIndicator();
      }

      final result = snapshot.data!;
      final crawlingList = result.crawlingList?.crawlingList ?? [];

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("참여한 활동", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (crawlingList.isEmpty)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("😎", style: TextStyle(fontSize: 40)),
                      SizedBox(width: 8),
                      Text("나에게 딱 맞는\n활동을 찾아보세요", textAlign: TextAlign.center),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, MainPageRouteNames.mainPage, (e) => false,
                      arguments: 3);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 20)),
                    child: const Text("보러가기", style: TextStyle(color: Colors.white),),
                  )
                ],
              )
            else
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: crawlingList.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final item = crawlingList[index];
                    return  SizedBox(
                      width: 100,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8), // 필요 시
                        child: Image.network(
                          item.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 20,),
            TextButton(
              onPressed: () async {
                final googleSignIn = getGoogleSignIn();
                if (await googleSignIn.isSignedIn()) {
                await googleSignIn.signOut();
                }
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, LoginPageRouteNames.loginPage, (routes) => false);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft,
              ),
              child: const Text(
                '로그아웃',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                await deleteUser();
                Navigator.pushNamedAndRemoveUntil(context, LoginPageRouteNames.loginPage, (routes) => false);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft,
              ),
              child: const Text(
                '탈퇴',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
