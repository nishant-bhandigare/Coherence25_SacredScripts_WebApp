import 'package:flutter/material.dart';
import 'package:urban_nest/features/community/community_post_card.dart';
import 'package:urban_nest/features/community/make_post.dart';
import 'package:urban_nest/features/community/posts_data.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  // Function to navigate and refresh posts
  Future<void> _navigateToAddPostPage() async {
    final newPost = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPostPage()),
    );

    // If a new post is returned, update the list
    if (newPost != null) {
      setState(() {
        communityPosts.insert(0, newPost);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BusinessIdeaText(),
              const SizedBox(height: 20),
              PostInputField(onPostCreated: _navigateToAddPostPage),
              const SizedBox(height: 20),
              const QuickAccessSection(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Activity Feed",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "View all",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: communityPosts.length,
                itemBuilder: (context, index) {
                  return CommunityPostCard(post: communityPosts[index]);
                },
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class PostInputField extends StatelessWidget {
  final VoidCallback onPostCreated;

  const PostInputField({super.key, required this.onPostCreated});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPostCreated,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(25),
        ),
        height: 60,
        child: Row(
          children: [
            const Expanded(
              child: Text(
                "Write here...",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: onPostCreated, // Use the same navigation callback
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.send, color: Colors.white, size: 18),
                  SizedBox(width: 4),
                  Text('Post now', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BusinessIdeaText extends StatelessWidget {
  const BusinessIdeaText({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: RichText(
        text: const TextSpan(
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          children: [
            TextSpan(text: "Share your "),
            TextSpan(
              text: "Business idea ",
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(text: "Today "),
            WidgetSpan(
              child: Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(Icons.lightbulb, color: Colors.amber, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Quick Access",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                debugPrint("View all clicked");
              },
              child: Text(
                "View all",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Scrollable Row of Cards
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              QuickAccessCard(
                title: "Discussion Forums",
                icon: Icons.forum,
                backgroundImage: "assets/images/abstract1.jpg",
              ),
              QuickAccessCard(
                title: "Investment Tools",
                icon: Icons.attach_money,
                backgroundImage: "assets/images/abstract2.jpg",
              ),
              QuickAccessCard(
                title: "Market Insights",
                icon: Icons.bar_chart,
                backgroundImage: "assets/images/abstract3.jpg",
              ),
              QuickAccessCard(
                title: "Business News",
                icon: Icons.newspaper,
                backgroundImage: "assets/images/abstract4.jpg",
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class QuickAccessCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String backgroundImage;

  const QuickAccessCard({
    super.key,
    required this.title,
    required this.icon,
    required this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Semi-transparent overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          // Icon & Text
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.8),
                  child: Icon(icon, color: Colors.black),
                ),
                Text(
                  title,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
