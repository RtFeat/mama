import 'package:flutter/material.dart';

class UniversalRuler extends StatefulWidget {
  final double min;
  final double max;
  final double step;
  final double initial;
  final double value;
  final ValueChanged<double>? onChanged;
  final String unit;
  final int labelStep;
  final String? Function(double value)? labelBuilder;

  const UniversalRuler({
    super.key,
    required this.min,
    required this.max,
    this.value = 0,
    required this.step,
    required this.unit,
    required this.labelStep,
    this.initial = 0,
    this.onChanged,
    this.labelBuilder,
  });

  @override
  State<UniversalRuler> createState() => _UniversalRulerState();
}

class _UniversalRulerState extends State<UniversalRuler> {
  late ScrollController _controller;
  late int _activeIndex;
  final double _itemWidth = 16;

  int get _itemCount => ((widget.max - widget.min) / widget.step).round() + 1;

  double _getValue(int index) =>
      double.parse((widget.min + index * widget.step).toStringAsFixed(2));

  @override
  void initState() {
    super.initState();
    _activeIndex = ((widget.initial - widget.min) / widget.step).round();
    _controller = ScrollController(
      initialScrollOffset: _activeIndex * _itemWidth,
    );
    _controller.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.jumpTo(_activeIndex * _itemWidth);
      widget.onChanged?.call(_getValue(_activeIndex));
    });
  }

  @override
  void didUpdateWidget(covariant UniversalRuler oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      final newIndex = ((widget.value - widget.min) / widget.step).round();
      if (newIndex != _activeIndex) {
        _activeIndex = newIndex;
        _controller.jumpTo(_activeIndex * _itemWidth);
      }
    }
  }

  EdgeInsets _sidePadding(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 2);

  void _onScroll() {
    final index =
        (_controller.offset / _itemWidth).round().clamp(0, _itemCount - 1);
    if (_activeIndex != index) {
      setState(() => _activeIndex = index);
      widget.onChanged?.call(_getValue(index));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ListView.builder(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              itemCount: _itemCount,
              padding: _sidePadding(context),
              itemBuilder: (context, index) {
                final value = _getValue(index);
                final stepsFromMin =
                    ((value - widget.min) / widget.step).round();
                final isLong = stepsFromMin % widget.labelStep == 0;
                final isEdge = index == 0 || index == _itemCount - 1;
                final showLabel = isLong || isEdge;
                final label = showLabel
                    ? (widget.labelBuilder?.call(value) ??
                        (value).toStringAsFixed(0))
                    : null;
                return _StickBlock(
                  isLong: isLong,
                  label: label,
                  itemWidth: _itemWidth,
                );
              },
            ),
            Positioned(
              top: 0,
              left: MediaQuery.of(context).size.width / 2 - 3,
              child: Column(
                children: [
                  Container(
                    width: 4,
                    height: 163,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.unit,
                    style: const TextStyle(
                      color: Color(0xFF4D4DE7),
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'SF Pro Text',
                      height: 1.18,
                      letterSpacing: -0.17,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StickBlock extends StatelessWidget {
  final bool isLong;
  final String? label;
  final double itemWidth;

  const _StickBlock({
    required this.isLong,
    required this.label,
    required this.itemWidth,
  });

  @override
  Widget build(BuildContext context) {
    double height = isLong ? 143 : 55;
    Color color = isLong ? Colors.black : Colors.grey[400]!;

    return SizedBox(
      width: itemWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 1,
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: SizedBox(
                width: 32,
                child: Center(
                  child: Text(
                    label!,
                    style: TextStyle(
                      color: color,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SF Pro Text',
                      height: 1.18,
                      letterSpacing: -0.17,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    softWrap: false,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
