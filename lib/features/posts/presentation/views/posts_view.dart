import 'package:flutter/material.dart';

import '../../models/post_model.dart';
import '../../repositories/post_repository.dart';
import '../widgets/post_tile.dart';

class PostsView extends StatefulWidget {
  const PostsView({super.key});

  @override
  State<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView>
    with AutomaticKeepAliveClientMixin<PostsView> {
  /// Posts future getter.
  /// Used for pull to refresh.
  Future<List<Post>> get _newFuture => PostRepository().getAllPosts();

  late Future<List<Post>> _postsFuture = _newFuture;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Post>>(
      future: _postsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) return const Center(child: Text('An error!'));

        if (!snapshot.hasData) {
          return const Center(child: Text('No data found!'));
        }

        final posts = snapshot.data!;

        if (posts.isEmpty) {
          return const Center(child: Text('No Posts found!'));
        }

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostTile(post: posts[index]);
            },
          ),
        );
      },
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _postsFuture = _newFuture;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
