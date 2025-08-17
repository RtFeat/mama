import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class TemperatureHistory extends StatelessWidget {
  final TemperatureStore store;

  const TemperatureHistory({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return SkitTableWidget(
      store: store,
    );
  }
}
