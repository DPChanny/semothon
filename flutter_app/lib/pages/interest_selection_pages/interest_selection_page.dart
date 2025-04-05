import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/dto/user_update_interest_dto.dart';
import 'package:flutter_app/routes/interest_page_routes.dart';
import 'package:flutter_app/services/queries/user_query.dart';

class InterestSelectionPage extends StatefulWidget {
  const InterestSelectionPage({super.key});

  @override
  State<InterestSelectionPage> createState() => _InterestSelectionPageState();
}

class _InterestSelectionPageState extends State<InterestSelectionPage> {
  Map<String, List<String>> keywords = {};
  final Set<String> selectedKeywords = {};
  String? expandedCategory;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadInitialKeywords();
  }

  Future<void> loadInitialKeywords() async {
    final String jsonStr = await rootBundle.loadString(
      'assets/interest_categories.json',
    );
    final Map<String, dynamic> data = jsonDecode(jsonStr);

    final Map<String, dynamic> subfields =
        data[UserUpdateInterestIntroDTO.instance.interestCategory];

    for (final entry in subfields.entries) {
      final String subfield = entry.key;
      final List<dynamic> items = entry.value;
      keywords[subfield] = List<String>.from(items);
    }

    setState(() {
      expandedCategory = keywords.keys.first;
      isLoading = false;
    });
  }

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
                            ? () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder:
                                    (context) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                              );

                              UserUpdateInterestIntroDTO
                                  .instance
                                  .interestNames = selectedKeywords.toList();

                              final result = await updateUserInterest();

                              Navigator.pop(context); // 로딩 다이얼로그 닫기

                              if (result.success) {
                                UserUpdateInterestIntroDTO
                                    .instance
                                    .generatedIntroText = result.introText;
                                Navigator.pushNamed(
                                  context,
                                  InterestPageRouteNames.introDetailPage,
                                );
                              } else {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  InterestPageRouteNames
                                      .interestCategorySelectionPage,
                                  (route) => false,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result.message)),
                                );
                              }
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
