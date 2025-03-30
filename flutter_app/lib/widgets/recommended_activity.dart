import 'package:flutter/material.dart';

class RecommendCardSlider extends StatefulWidget {
  @override
  _RecommendCardSliderState createState() => _RecommendCardSliderState();
}

class _RecommendCardSliderState extends State<RecommendCardSlider> {
  final PageController _pageController = PageController(viewportFraction: 0.75);
  int _currentPage = 0;

  final List<RecommendActivity> activities = [
    RecommendActivity(
      imageUrl: 'https://your-server.com/image1.png',
      title: 'CJ 제일제당\nFuture Marketer League',
      deadline: '04/10 마감',
      prize: '800만원',
      tags: ['기획 아이디어', '광고 마케팅'],
    ),
    // ... 최대 5개까지
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: PageView.builder(
        controller: _pageController,
        itemCount: activities.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          final activity = activities[index];
          final isCurrent = index == _currentPage;

          return AnimatedScale(
            scale: isCurrent ? 1.0 : 0.92,
            duration: Duration(milliseconds: 300),
            child: Opacity(
              opacity: isCurrent ? 1.0 : 0.6,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 6),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        activity.imageUrl,
                        width: 80,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(activity.deadline,
                              style: TextStyle(color: Colors.grey[700])),
                          Text('${activity.prize}',
                              style: TextStyle(color: Colors.grey[700])),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            children: activity.tags.map((tag) {
                              return Chip(
                                label: Text('#$tag',
                                    style: TextStyle(fontSize: 12)),
                                backgroundColor: Colors.blue[50],
                                shape: StadiumBorder(),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class RecommendActivity {
  final String imageUrl;
  final String title;
  final String deadline;
  final String prize;
  final List<String> tags;

  RecommendActivity({
    required this.imageUrl,
    required this.title,
    required this.deadline,
    required this.prize,
    required this.tags,
  });
}
