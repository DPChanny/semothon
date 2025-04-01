import 'dart:math';

import 'package:flutter_app/dto/room_dto.dart';
import 'package:flutter_app/dto/user_dto.dart';

final List<RoomDTO> dummyRooms = [
  RoomDTO(
    roomId: 1,
    title: '프론트 빡시기',
    description: '현업과 선배들이 이야기하는 코딩 진로를 위한 여러가지 추천 활동들',
    capacity: 3,
    createdAt: '2024-04-01T10:00:00',
    host: UserDTO(
      userId: '',
      nickname: '프론트GOAT',
      socialProvider: '',
      socialId: '',
      createdAt: DateTime.now(),
    ),
  ),
  RoomDTO(
    roomId: 2,
    title: '백엔드 마스터 플랜',
    description: 'Spring Boot, Node.js를 마스터하는 백엔드 특강 스터디',
    capacity: 5,
    createdAt: '2024-04-02T11:30:00',
    host: UserDTO(
      userId: '',
      nickname: '노드마스터',
      socialProvider: '',
      socialId: '',
      createdAt: DateTime.now(),
    ),
  ),
  RoomDTO(
    roomId: 3,
    title: 'UX/UI 실전 디자인',
    description: 'Figma와 Adobe XD로 실무 디자인 워크숍',
    capacity: 1,
    createdAt: '2024-04-03T13:45:00',
    host: UserDTO(
      userId: '',
      nickname: '예술적인 소프트웨어',
      socialProvider: '',
      socialId: '',
      createdAt: DateTime.now(),
    ),
  ),
  RoomDTO(
    roomId: 4,
    title: 'AI & 머신러닝 입문',
    description: '파이썬으로 시작하는 인공지능/머신러닝 입문자 모임',
    capacity: 8,
    createdAt: '2024-04-04T09:00:00',
    host: UserDTO(
      userId: '',
      nickname: 'ML마스터',
      socialProvider: '',
      socialId: '',
      createdAt: DateTime.now(),
    ),
  ),
  RoomDTO(
    roomId: 5,
    title: '코테 같이 풀자',
    description: '백준/프로그래머스 알고리즘 문제를 함께 풀며 실력 향상',
    capacity: 1,
    createdAt: '2024-04-05T18:20:00',
    host: UserDTO(
      userId: '',
      nickname: '백준권위자',
      socialProvider: '',
      socialId: '',
      createdAt: DateTime.now(),
    ),
  ),
  RoomDTO(
    roomId: 6,
    title: '면접 스터디',
    description: 'IT 기업 기술 면접 및 인성 면접 대비 토론과 피드백',
    capacity: 6,
    createdAt: '2024-04-06T16:10:00',
    host: UserDTO(
      userId: '',
      nickname: '면접왕',
      socialProvider: '',
      socialId: '',
      createdAt: DateTime.now(),
    ),
  ),
  RoomDTO(
    roomId: 7,
    title: '데이터 분석 뽀개기',
    description: 'Pandas, SQL, Tableau까지 실무 분석 집중 과정',
    capacity: 3,
    createdAt: '2024-04-07T14:00:00',
    host: UserDTO(
      userId: '',
      nickname: '데이터장인',
      socialProvider: '',
      socialId: '',
      createdAt: DateTime.now(),
    ),
  ),
  RoomDTO(
    roomId: 8,
    title: '캡스톤 디자인 팀 매칭',
    description: '디자인/기획/개발 학생들을 위한 협업 팀 매칭방',
    capacity: 2,
    createdAt: '2024-04-08T13:25:00',
    host: UserDTO(
      userId: '',
      nickname: '프로젝트고인물',
      socialProvider: '',
      socialId: '',
      createdAt: DateTime.now(),
    ),
  ),
  RoomDTO(
    roomId: 9,
    title: '해커톤 팀 찾기',
    description: '다양한 주제로 해커톤 팀원 모집 중!',
    capacity: 9,
    createdAt: '2024-04-09T10:50:00',
    host: UserDTO(
      userId: '',
      nickname: '해커톤광인',
      socialProvider: '',
      socialId: '',
      createdAt: DateTime.now(),
    ),
  ),
  RoomDTO(
    roomId: 10,
    title: '모의 프로젝트 진행방',
    description: '실제처럼 주제 선정, 개발, 발표까지 모의 프로젝트를 경험해요',
    capacity: 8,
    createdAt: '2024-04-10T17:40:00',
    host: UserDTO(
      userId: '',
      nickname: 'PM의신',
      socialProvider: '',
      socialId: '',
      createdAt: DateTime.now(),
    ),
  ),
];

List<RoomDTO> randomRooms(int n) {
  final random = Random();
  final List<RoomDTO> copy = List<RoomDTO>.from(dummyRooms);
  copy.shuffle(random);
  return copy.sublist(0, n.clamp(0, copy.length));
}
