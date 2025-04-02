import 'package:flutter/material.dart';

class InterestCategorySelectionPage extends StatefulWidget {
  const InterestCategorySelectionPage({super.key});

  @override
  State<InterestCategorySelectionPage> createState() =>
      _InterestCategorySelectionPageState();
}

class _InterestCategorySelectionPageState
    extends State<InterestCategorySelectionPage> {
  final Map<String, List<String>> keywords = {
    '미술': [
      '산업디자인',
      '시각디자인',
      '패션디자인',
      '콘텐츠 디자인',
      '도예',
      '공간디자인',
      '웹툰 & 디자인',
      '조형',
      '순수디자인',
      '회화',
      '서양화',
      '동양화',
    ],
    '음악': ['성악', '기악', '작곡', '실용음악', '지휘', '음악교육', '뮤지컬', '음향디자인'],
    '체육': ['체육학', '스포츠과학', '무용', '무예', '레저스포츠', '생활체육', '재활운동', '스포츠의학'],
    '디자인': [
      '산업디자인',
      '시각디자인',
      '패션디자인',
      '콘텐츠 디자인',
      'UX/UI',
      '공간디자인',
      '조형디자인',
      '인터랙션디자인',
    ],
  };

  final Set<String> selectedKeywords = {};
  String? expandedCategory = '미술';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  '선호도 선택',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontFamily: 'Noto Sans KR',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.29,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Stack(
                children: [
                  Container(
                    height: 4,
                    width: double.infinity,
                    color: const Color(0xFFE4E4E4),
                  ),
                  Container(
                    height: 4,
                    width: MediaQuery.of(context).size.width * 0.66,
                    color: const Color(0xFF008CFF),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                '세부적인 키워드를 \n선택해 주세요.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w700,
                  height: 1.42,
                  letterSpacing: -0.41,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '최대 10개까지 선택 가능합니다.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.26,
                ),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: ListView(
                  children:
                      keywords.entries.map((entry) {
                        final category = entry.key;
                        final items = entry.value;
                        final isExpanded = expandedCategory == category;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              decoration: BoxDecoration(
                                color:
                                    isExpanded
                                        ? const Color(0xFFF5F5F5)
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    expandedCategory =
                                        isExpanded ? null : category;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      isExpanded
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      category,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight:
                                            isExpanded
                                                ? FontWeight.w700
                                                : FontWeight.w400,
                                        fontFamily: 'Noto Sans KR',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (isExpanded && items.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children:
                                    items.map((keyword) {
                                      final isSelected = selectedKeywords
                                          .contains(keyword);
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (isSelected) {
                                              selectedKeywords.remove(keyword);
                                            } else {
                                              if (selectedKeywords.length <
                                                  10) {
                                                selectedKeywords.add(keyword);
                                              }
                                            }
                                          });
                                        },
                                        child: Container(
                                          width: 110,
                                          height: 28,
                                          alignment: Alignment.center,
                                          decoration: ShapeDecoration(
                                            color:
                                                isSelected
                                                    ? const Color(0xFF008CFF)
                                                    : Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                width: 1,
                                                color: Color(0xFF008CFF),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                          ),
                                          child: Text(
                                            keyword,
                                            style: TextStyle(
                                              color:
                                                  isSelected
                                                      ? Colors.white
                                                      : Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Noto Sans KR',
                                              letterSpacing: -0.26,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ],
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: SizedBox(
                  width: 335,
                  height: 47,
                  child: ElevatedButton(
                    onPressed:
                        selectedKeywords.isNotEmpty
                            ? () {
                              // TODO: 저장 후 다음 단계로 이동
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedKeywords.isNotEmpty
                              ? const Color(0xFF008CFF)
                              : const Color(0xFFE4E4E4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23.5),
                      ),
                    ),
                    child: Text(
                      '다음',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Noto Sans KR',
                        color:
                            selectedKeywords.isNotEmpty
                                ? Colors.white
                                : const Color(0xFFB1B1B1),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
