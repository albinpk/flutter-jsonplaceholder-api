import 'package:flutter/material.dart';

import '../../models/album_model.dart';
import '../../repositories/albums_repository.dart';
import '../widgets/album_tile.dart';

class AlbumsView extends StatefulWidget {
  const AlbumsView({super.key});

  @override
  State<AlbumsView> createState() => _AlbumsViewState();
}

class _AlbumsViewState extends State<AlbumsView>
    with AutomaticKeepAliveClientMixin<AlbumsView> {
  /// Albums future getter.
  /// Used for pull to refresh.
  Future<List<Album>> get _newFuture => AlbumRepository().getAllAlbums();

  late Future<List<Album>> _albumsFuture = _newFuture;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Album>>(
      future: _albumsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) return const Center(child: Text('An error!'));

        if (!snapshot.hasData) {
          return const Center(child: Text('No data found!'));
        }

        final albums = snapshot.data!;

        if (albums.isEmpty) {
          return const Center(child: Text('No Albums found!'));
        }

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            itemCount: albums.length,
            itemBuilder: (context, index) {
              return AlbumTile(album: albums[index]);
            },
          ),
        );
      },
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _albumsFuture = _newFuture;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
