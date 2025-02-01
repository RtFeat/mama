import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class MusicViewBody extends StatefulWidget {
  final MusicStore store;
  final TrackCategory category;
  const MusicViewBody({
    super.key,
    required this.store,
    required this.category,
  });

  @override
  State<MusicViewBody> createState() => _MusicViewBodyState();
}

class _MusicViewBodyState extends State<MusicViewBody> {
  @override
  void initState() {
    widget.store.resetPagination();
    widget.store.loadPage(
      fetchFunction: (query, client, path) {
        final filterPath = switch (widget.category) {
          TrackCategory.music => TrackCategory.music.name,
          TrackCategory.whiteNoise => TrackCategory.whiteNoise.name,
          TrackCategory.story => TrackCategory.story.name,
        };
        return client.get('$path/$filterPath', queryParams: query);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedLoadingWidget(
      store: widget.store,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (context, item, _) {
        return TrackWidget(model: item);
      },
    );
  }
}
