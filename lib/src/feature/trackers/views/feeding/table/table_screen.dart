import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  late FeedingStore _store;

  @override
  void initState() {
    super.initState();
    _store = FeedingStore(
      faker: context.read<Dependencies>().faker,
      apiClient: context.read<Dependencies>().apiClient,
      userStore: context.read<UserStore>(),
    );
    _store.activate();
  }

  @override
  void dispose() {
    _store.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: _store,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TableFeedHistory(
            store: _store,
            showTitle: true,
            title: t.trackers.report,
          ),
        ),
      ),
    );
  }
}
