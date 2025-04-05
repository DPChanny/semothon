import 'package:flutter/material.dart';

class Activity {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> tags;

  Activity({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.tags,
  });
}

final List<Activity> recommendedList = [
  Activity(
    title: 'Cat Contest',
    description: 'Show off your cute cat!',
    imageUrl: 'https://placekitten.com/200/200',
    tags: ['cat', 'contest'],
  ),
  Activity(
    title: 'Cute Paw Competition',
    description: 'Find the world’s cutest paw!',
    imageUrl: 'https://placekitten.com/201/200',
    tags: ['cat', 'cute'],
  ),
];

final List<Activity> latestActivities = [
  Activity(
    title: 'Cat Contest',
    description:
    'Cats are cute. Because they are. I’m cute too, but not as much as cats... So...',
    imageUrl: 'https://placekitten.com/300/200',
    tags: ['coding', 'challenge'],
  ),
];

class CrawlingTab extends StatelessWidget {
  const CrawlingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Activities'),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: const [
          Icon(Icons.search),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPersonalRecommendation(),
            const SizedBox(height: 24),
            _buildLatestActivities(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ✅ Personal recommendation section
  Widget _buildPersonalRecommendation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: const [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Semo Kim',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                        text: ', these activities are just for you!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recommendedList.length,
            itemBuilder: (context, index) {
              final activity = recommendedList[index];
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(activity.imageUrl, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      activity.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '#${activity.tags.first}',
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ✅ Latest activity section
  Widget _buildLatestActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: const [
              Expanded(
                child: Text(
                  'New',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Check out the latest recommended activities',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.85),
            itemCount: latestActivities.length,
            itemBuilder: (context, index) {
              final activity = latestActivities[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        activity.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '#${activity.tags.join(" #")}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
