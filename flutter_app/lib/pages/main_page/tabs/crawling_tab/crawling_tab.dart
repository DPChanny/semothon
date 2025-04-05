import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/dto/crawling_info_dto.dart';
import 'package:flutter_app/pages/main_page/tabs/crawling_tab/crawling_detail.dart';
import 'package:flutter_app/services/queries/crawling_query.dart';

enum SortType { recommendation, recent }

class CrawlingTab extends StatefulWidget {
  const CrawlingTab({super.key});

  @override
  State<CrawlingTab> createState() => _CrawlingTabState();
}

class _CrawlingTabState extends State<CrawlingTab> {
  List<CrawlingInfoDto> items = [];
  SortType selectedSort = SortType.recommendation;

  @override
  void initState() {
    super.initState();
    _fetchCrawlings(); // 초기 로딩 (추천순)
  }

  Future<void> _fetchCrawlings() async {
    final sortBy = selectedSort == SortType.recommendation ? 'SCORE' : 'CRAWLED_AT';
    final result = await getCrawlingList(sortBy: sortBy);

    if (result.success && result.crawlingList != null) {
      setState(() {
        items = result.crawlingList!.crawlingList.take(10).toList();
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message)),
        );
      }
    }
  }

  Widget _buildRecommendationCard(CrawlingInfoDto crawling) {
    return _buildGenericCard(crawling);
  }

  Widget _buildRecentCard(CrawlingInfoDto crawling) {
    return _buildGenericCard(crawling);
  }

  Widget _buildGenericCard(CrawlingInfoDto crawling) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => CrawlingDetailPage(dto: crawling),
          ),);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  crawling.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crawling.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      crawling.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: crawling.interests.map((interest) {
                        return Text(
                          '#$interest',
                          style: const TextStyle(
                            color: Color(0xFF007BFF),
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList(),
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

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'AI의 맞춤 추천',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSort = SortType.recommendation;
                          });
                          _fetchCrawlings();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedSort == SortType.recommendation
                                ? const Color(0xFF007BFF)
                                : const Color(0xFFF1F1F1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Text(
                            '추천순',
                            style: TextStyle(
                              color: selectedSort == SortType.recommendation
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSort = SortType.recent;
                          });
                          _fetchCrawlings();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedSort == SortType.recent
                                ? const Color(0xFF007BFF)
                                : const Color(0xFFF1F1F1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Text(
                            '최신순',
                            style: TextStyle(
                              color: selectedSort == SortType.recent
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final dto = items[index];
                  return selectedSort == SortType.recommendation
                      ? _buildRecommendationCard(dto)
                      : _buildRecentCard(dto);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
