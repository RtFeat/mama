import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';
import 'package:mama/src/feature/feeding/data/repository/feeding_repository.dart';
import 'package:mama/src/feature/feeding/widgets/widget.dart';

class PumpingGraphicWidget extends StatelessWidget {
  const PumpingGraphicWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: GraphicWidget(
          listOfData: getPumpingData(),
          topColumnText: t.feeding.l,
          bottomColumnText: t.feeding.r,
          minimum: 0,
          maximum: 150,
          interval: 50),
    );
  }
}
