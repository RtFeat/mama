import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class ItemsLineWidget<T> extends StatelessWidget {
  final double height;
  final List<T> data;
  final Color? backgroundColor;
  final Function(T data, bool isFirst, bool isLast) builder;

  const ItemsLineWidget({
    super.key,
    required this.height,
    required this.data,
    required this.builder,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.lightBlueBackgroundStatus,
          borderRadius: 24.r,
        ),
        child: Row(
          children: data.mapIndexed((i, e) {
            final child = builder(data[i], i == 0, i == data.length - 1);

            // Добавляем Divider между элементами, кроме последнего
            if (i < data.length - 1) {
              return Expanded(
                child: Row(
                  children: [
                    Expanded(child: child),
                    const VerticalDivider(
                      width: 2,
                      thickness: 1,
                      color: Colors.white,
                    ),
                  ],
                ),
              );
            }

            return Expanded(child: child);
          }).toList(),
        ),
      ),
    );
  }
}
