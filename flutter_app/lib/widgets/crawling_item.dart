import 'package:flutter/material.dart';
import 'package:flutter_app/dto/crawling_info_dto.dart';
import 'package:flutter_app/pages/main_page/tabs/crawling_tab/crawling_detail.dart';
Widget crawlingItem(BuildContext context, CrawlingInfoDto item) {
  return SizedBox(
    width: 107.4,
    height: 170.44,
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(4), // 원하는 정도로 조정
      elevation: 2,
      shadowColor: Colors.black12,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () {
          // 페이지 이동
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CrawlingDetailPage(dto: item),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼 이미지 영역
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 100,
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 🔵 파란 정보 영역
            Container(
              height: 70.44,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: const BoxDecoration(
                color: Color(0xFF008CFF),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Noto Sans KR',
                        fontWeight: FontWeight.w700,
                        height: 1.33,
                        letterSpacing: -0.20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      item.interests.map((tag) => '#$tag').join('   '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: 'Noto Sans KR',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
