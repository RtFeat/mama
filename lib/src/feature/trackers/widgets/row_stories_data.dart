import 'package:flutter/material.dart';
import 'package:skit/skit.dart';

class RowStroriesData extends StatelessWidget {
  const RowStroriesData({
    super.key,
    required this.data,
    this.week,
    this.weight,
    this.growth,
    this.head,
    required this.style,
  });

  final String data;
  final String? week;
  final String? weight;
  final String? growth;
  final String? head;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(data, style: style),
        Row(
          children: [
            Text(week ?? '', style: style),
            40.w,
            Text(weight ?? '', style: style),
            weight == null ? const SizedBox() : 30.w,
            Text(growth ?? '', style: style),
            growth == null ? const SizedBox() : 30.w,
            Text(head ?? '', style: style),
            // head == null ? const SizedBox() : const SizedBox(width: 30),
          ],
        ),
      ],
    );
  }
}
