import 'package:flutter/material.dart';

import 'package:flutter_app/dto/crawling_dto.dart';

Widget crawlingItem(BuildContext context, CrawlingDto item) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 6)),
      ],
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 100, maxHeight: 150),
            child: AspectRatio(
              aspectRatio: 3.25 / 5, // 너비:높이 = 4:5
              child: Image.network(item.imageUrl ?? '', fit: BoxFit.cover),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              Text(
                '마감일: ${item.publishedAt?.toString().split(' ').first ?? '미정'}',
                style: TextStyle(color: Colors.grey[700]),
              ),
              Text(
                item.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
