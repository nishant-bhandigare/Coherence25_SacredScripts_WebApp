import 'package:flutter/material.dart';
import 'package:urban_nest/features/community/posts_data_model.dart';

class CommunityPostCard extends StatelessWidget {
  final CommunityPost post;

  const CommunityPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // User Info Row
            Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(post.profileImage),
                      radius: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                post.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (post.isVerified)
                                const Icon(Icons.verified, color: Colors.blue, size: 18),
                            ],
                          ),
                          Text(
                            post.time,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.more_horiz, color: Colors.grey),
                  ],
                ),
                Divider(),
              ],
            ),
            const SizedBox(height: 6),

            // Category Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                post.category,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.blue),
              ),
            ),

            const SizedBox(height: 8),

            // Post Content
            Text(
              post.content,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 12),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(Icons.thumb_up_alt_outlined, post.likes),
                _buildActionButton(Icons.comment_outlined, post.comments),
                _buildActionButton(Icons.share_outlined, post.shares),
                _buildActionButton(Icons.remove_red_eye_outlined, post.views),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 20),
        const SizedBox(width: 4),
        Text(count.toString(), style: TextStyle(color: Colors.grey.shade700)),
      ],
    );
  }
}
