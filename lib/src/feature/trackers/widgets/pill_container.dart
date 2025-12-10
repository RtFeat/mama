import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class PillContainerWidget extends StatelessWidget {
  final String? imageUrl;
  final String? imagePath;
  final List<Widget> children;
  final EdgeInsets? contentPadding;
  final CrossAxisAlignment? crossAxisAlignment;
  const PillContainerWidget({
    super.key,
    this.imageUrl,
    this.imagePath,
    required this.children,
    this.contentPadding,
    this.crossAxisAlignment,
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
            crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
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
              Expanded(
                  child: Padding(
                padding: contentPadding ?? EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: children,
                ),
              )),
            ]));
  }
}
