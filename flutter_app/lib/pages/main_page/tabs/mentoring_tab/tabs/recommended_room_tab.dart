import 'package:flutter/material.dart';
import 'package:flutter_app/dto/get_room_list_response_dto.dart';
import 'package:flutter_app/services/queries/room_query.dart';
import 'package:flutter_app/widgets/room_item.dart';
import 'package:flutter_app/widgets/room_pop_up.dart';

class RecommendedRoomTab extends StatelessWidget {
  const RecommendedRoomTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GetRoomListResponseDto>(
      future: getRoomList(sortBy: "SCORE", excludeJoined: true),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('방 목록을 불러오지 못했어요: ${snapshot.error}'));
        }

        final rooms = snapshot.data!.roomInfos;
        final hostInfos = snapshot.data!.hostInfos;

        return ListView.builder(
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            final room = rooms[index];
            final hostUser = hostInfos[index];
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  isScrollControlled: true,
                  builder:
                      (context) => RoomPopUp(room: room, hostUser: hostUser),
                );
              },
              child: RoomItem(room: room, index: index),
            );
          },
        );
      },
    );
  }
}
