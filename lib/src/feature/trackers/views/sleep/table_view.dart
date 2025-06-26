import 'package:faker_dart/faker_dart.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class TableScreen extends StatelessWidget {
  const TableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => SleepCryStore(
          faker: context.read<Dependencies>().faker,
          apiClient: context.read<Dependencies>().apiClient),
      builder: (context, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TableSleepHistory(
            store: context.watch(),
            showTitle: true,
            title: t.trackers.report,
            childId: context.watch<UserStore>().selectedChild?.id,
          ),
        ),
      ),
    );
  }
}
