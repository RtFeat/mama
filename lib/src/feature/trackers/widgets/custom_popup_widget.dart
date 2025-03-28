// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class CustomPopupWidget extends StatefulWidget {
  const CustomPopupWidget({
    super.key,
    required this.selectedIndex,
    this.closeButton,
  });
  final int selectedIndex;
  final void Function()? closeButton;

  @override
  _CustomPopupWidgetState createState() => _CustomPopupWidgetState();
}

class _CustomPopupWidgetState extends State<CustomPopupWidget> {
  // Состояние для отслеживания выбранного элемента
  String selectedOption = '';
  List<String> options = [];

  @override
  Widget build(BuildContext context) {
    widget.selectedIndex == 0
        ? options = [...t.trackers.list_of_wet]
        : options = [...t.trackers.list_of_mixed];
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: 0.5),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2), // Смещение тени
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 5,
                    children: [
                      // Кнопка закрытия
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: InkWell(
                          onTap: widget.closeButton,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      for (var option in options)
                        ChoiceChip(
                          label: Text(option),
                          labelStyle: AppTextStyles.f17w400.copyWith(
                            color: AppColors.primaryColor,
                          ),
                          selected: selectedOption == option,
                          selectedColor: AppColors.primaryColor,
                          color: const WidgetStatePropertyAll(
                              AppColors.whiteColor),
                          onSelected: (bool selected) {
                            setState(() {
                              selectedOption = selected ? option : '';
                            });
                          },
                          shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(color: AppColors.primaryColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        )
                    ],
                  ),
                  8.h,
                ],
              ),
            ),
            12.h,
          ],
        ),
        // Стрелка внизу
        Positioned(
          bottom: 0,
          right: widget.selectedIndex == 0
              ? MediaQuery.of(context).size.width * 0.75
              : widget.selectedIndex == 1
                  ? MediaQuery.of(context).size.width * 0.45
                  : MediaQuery.of(context).size.width * 0.12,
          child: CustomPaint(
            size: const Size(20, 15),
            painter: TrianglePainter(),
          ),
        ),
      ],
    );
  }
}

// Класс для рисования треугольной стрелки
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    final path = Path();
    path.moveTo(0, 0); // Левый угол
    path.lineTo(size.width / 2, size.height); // Нижняя точка
    path.lineTo(size.width, 0); // Правый угол
    path.close(); // Замыкаем путь

    // Рисуем тень для треугольника
    canvas.drawShadow(path, Colors.grey, 3.0, true);

    // Рисуем сам треугольник
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
