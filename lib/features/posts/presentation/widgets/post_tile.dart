import 'package:flutter/material.dart';

import '../../models/post_model.dart';
import '../screens/post_screen.dart';

class PostTile extends StatelessWidget {
  const PostTile({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 10,
      leading: const Icon(Icons.newspaper, size: 30),
      title: Text(
        post.title,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        post.body,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.grey),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return PostScreen(postId: post.id);
            },
          ),
        );
      },
    );
  }
}
