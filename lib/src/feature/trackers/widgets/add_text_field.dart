import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class AddSomethingTextField extends StatelessWidget {
  const AddSomethingTextField({
    super.key,
    required this.hintText,
    required this.title,
    this.controller,
  });

  final String hintText;
  final String title;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              maxLines: 4,
              minLines: 1,
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTextStyles.f17w400
                    .copyWith(color: AppColors.greyBrighterColor),
                border: InputBorder.none,
              ),
            ),
            Text(
              title,
              style: AppTextStyles.f10w700
                  .copyWith(color: AppColors.greyBrighterColor),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
