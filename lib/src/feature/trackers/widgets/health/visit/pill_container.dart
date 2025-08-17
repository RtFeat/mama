import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class PillAndDocVisitContainer extends StatelessWidget {
  final String? imageUrl;
  final String? imagePath;
  final String title;
  final DateTime? timeDate;
  final String? description;

  const PillAndDocVisitContainer({
    super.key,
    required this.title,
    this.timeDate,
    this.description,
    this.imageUrl,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return PillContainerWidget(
      imageUrl: imageUrl,
      imagePath: imagePath,
      children: [
        /// #pill title
        AutoSizeText(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 1,
        ),
        8.h,

        /// #pill exact time, pill remaining time

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// #pill exact time
            if (timeDate != null)
              AutoSizeText(
                timeDate!.dateWithMonth,
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontSize: 14),
              ),

            /// #pill remaining time
            if (description != null && description!.isNotEmpty) ...[
              8.h,
              Row(
                children: [
                  Expanded(
                    child: Text(
                      description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(fontSize: 10),
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ],
    );
  }
}
