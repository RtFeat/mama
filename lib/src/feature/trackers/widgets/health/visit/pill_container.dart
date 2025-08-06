import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
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
    required this.timeDate,
    this.description,
    this.imageUrl,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final ChatSocketFactory socket = context.watch<ChatSocketFactory>();
    final token = socket.socket.accessToken;

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.whiteDarkerButtonColor,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Row(
        children: [
          /// #pill image

          imagePath != null || imageUrl != null
              ? Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: imagePath != null
                          ? FileImage(File(imagePath!)) as ImageProvider
                          : CachedNetworkImageProvider(imageUrl!, headers: {
                              'Authorization': 'Bearer $token',
                            }),
                    ),
                  ),
                )
              : const DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.purpleLighterBackgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Center(
                      child: Icon(AppIcons.pillsFill,
                          color: AppColors.primaryColor, size: 28),
                    ),
                  ),
                ),
          16.w,

          /// #pill details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            ),
          ),
        ],
      ),
    );
  }
}
