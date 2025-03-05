import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class TableScreen extends StatelessWidget {
  const TableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) =>
          FeedingStore(apiClient: context.read<Dependencies>().apiClient),
      builder: (context, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TableFeedHistory(
            store: context.watch(),
            showTitle: true,
            title: t.trackers.report,
          ),
        ),
      ),
    );
  }
}
