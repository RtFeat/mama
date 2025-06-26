import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class TemperatureHistory extends StatefulWidget {
  final TemperatureStore store;
  final String? title;
  final String? childId;

  const TemperatureHistory({
    super.key,
    required this.store,
    this.title,
    this.childId,
  });

  @override
  State<TemperatureHistory> createState() => _TemperatureHistoryState();
}

class _TemperatureHistoryState extends State<TemperatureHistory> {
  @override
  void initState() {
    widget.store.loadPage(newFilters: [
      SkitFilter(
          field: 'child_id',
          operator: FilterOperator.equals,
          value: widget.childId),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return SkitTableWidget(
      store: widget.store,
    );
  }
}
