import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class DrugWidget extends StatelessWidget {
  final String? imageUrl;
  final String? imagePath;
  final EntityMainDrug model;

  const DrugWidget({
    super.key,
    required this.model,
    this.imageUrl,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final bool needCenter = model.dose?.isEmpty ??
        model.reminder.isEmpty && model.reminderAfter.isEmpty;

    return PillContainerWidget(
      imageUrl: imageUrl,
      imagePath: imagePath,
      contentPadding: EdgeInsets.symmetric(vertical: 8),
      crossAxisAlignment:
          needCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        /// #pill title
        AutoSizeText(
          model.name ?? '',
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
            // if (timeDate != null)
            //   AutoSizeText(
            //     timeDate!.dateWithMonth,
            //     maxLines: 1,
            //     style: Theme.of(context)
            //         .textTheme
            //         .labelMedium
            //         ?.copyWith(fontSize: 14),
            //   ),

            if (model.dose != null && model.dose!.isNotEmpty)
              Text(
                model.dose ?? '',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontSize: 14),
              ),
            if (model.reminder.isNotEmpty && model.reminderAfter.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  8.h,
                  Text(
                    'В ${model.reminder.first.split(':').take(2).join(':')}',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontSize: 14),
                  ),
                  Text(
                    model.reminderAfter.first,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontSize: 14),
                  ),
                ],
              )

            /// #pill remaining time
            // if (description != null && description!.isNotEmpty) ...[
            //   8.h,
            //   Row(
            //     children: [
            //       Expanded(
            //         child: Text(
            //           description!,
            //           maxLines: 2,
            //           overflow: TextOverflow.ellipsis,
            //           style: Theme.of(context)
            //               .textTheme
            //               .labelMedium
            //               ?.copyWith(fontSize: 10),
            //         ),
            //       ),
            //     ],
            //   ),
            // ]
          ],
        ),
      ],
    );
  }
}
