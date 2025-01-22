import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mama/src/data.dart';

class AddPhoto extends StatelessWidget {
  const AddPhoto({
    super.key,
    this.onTap,
    this.image,
  });

  final void Function()? onTap;
  final XFile? image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 358,
        width: double.infinity,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.primaryColorBrighter,
              ),
              child: const DashBorder(),
            ),
            Center(
              child: image == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/icons/add_photo_ic.png',
                            height: 32),
                        const SizedBox(height: 8),
                        Text(
                          'Добавить фото',
                          style: AppTextStyles.f17w400
                              .copyWith(color: AppColors.primaryColor),
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        File(image!.path),
                        fit: BoxFit.cover,
                        height: 358,
                        width: double.infinity,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// DashBorder виджет для пунктирной рамки
class DashBorder extends StatelessWidget {
  const DashBorder({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 358),
      painter: DashBorderPainter(),
    );
  }
}

class DashBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double dashWidth = 5; // Длина штриха
    const double dashSpace = 5; // Расстояние между штрихами
    final Paint paint = Paint()
      ..color = AppColors.primaryColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(
            0, 0, size.width, size.height), // Используем переданный размер
        const Radius.circular(20), // Радиус для углов
      ));

    double dashOffset = 0.0;
    while (dashOffset < path.computeMetrics().first.length) {
      final extractPath = path.computeMetrics().first.extractPath(
          dashOffset, dashOffset + dashWidth,
          startWithMoveTo: true);
      canvas.drawPath(extractPath, paint);
      dashOffset += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
