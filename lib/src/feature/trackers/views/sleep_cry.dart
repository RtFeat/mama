import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class SleepCryView extends StatelessWidget {
  const SleepCryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => SleepCryStore(
        apiClient: context.read<Dependencies>().apiClient,
        faker: context.read<Dependencies>().faker,
      ),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: Text(t.trackers.sleepCry),
        ),
        body: _Body(
          store: context.watch(),
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final SleepCryStore store;
  const _Body({
    required this.store,
  });

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  @override
  void initState() {
    widget.store.loadPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SkitTableWidget(store: widget.store);
  }
}
