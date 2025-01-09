import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class MusicViewBody extends StatefulWidget {
  final MusicStore store;
  const MusicViewBody({
    super.key,
    required this.store,
  });

  @override
  State<MusicViewBody> createState() => _MusicViewBodyState();
}

class _MusicViewBodyState extends State<MusicViewBody> {
  @override
  void initState() {
    widget.store.loadPage(queryParams: {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedLoadingWidget(
      store: widget.store,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (context, item) {
        return TrackWidget(model: item);
      },
    );
  }
}
