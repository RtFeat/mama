import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class AssetItemWidget extends StatelessWidget {
  final MessageFile asset;
  final bool? needIcon;
  final VoidCallback onTapDelete;
  const AssetItemWidget(
      {super.key,
      required this.asset,
      required this.onTapDelete,
      this.needIcon = false});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    const double size = 64;

    return SizedBox(
      width: size,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.topRight,
            clipBehavior: Clip.none,
            children: [
              _Asset(asset: asset, size: size),
              Positioned(
                right: -5,
                top: -5,
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      onTapDelete();
                    },
                    child: const CircleAvatar(
                      radius: 10,
                      backgroundColor: AppColors.redColor,
                      child: Icon(Icons.close,
                          size: 15, color: AppColors.whiteColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(
            maxLines: 1,
            asset.filename ?? '',
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelSmall!.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _Asset extends StatelessWidget {
  final double size;
  final MessageFile asset;

  const _Asset({required this.asset, required this.size});

  @override
  Widget build(BuildContext context) {
    switch (asset.typeFile) {
      case 'jpg' || 'jpeg' || 'png':
        return ClipRRect(
            borderRadius: 6.r,
            child: asset.filePath != null
                ? Image.file(
                    File(asset.filePath!),
                    height: size,
                    width: size,
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    imageUrl:
                        '${const AppConfig().apiUrl}chat/message/file/${asset.fileUrl!}.${asset.typeFile}',
                    height: size,
                    width: size,
                    fit: BoxFit.cover,
                  ));
      default:
        return _FileAsset(size: size, asset: asset);
    }
  }
}

class _FileAsset extends StatefulWidget {
  final double size;
  final MessageFile asset;
  const _FileAsset({required this.size, required this.asset});

  @override
  State<_FileAsset> createState() => __FileAssetState();
}

class __FileAssetState extends State<_FileAsset> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return GestureDetector(
      onTap: () {
        // if (!isDownloaded) {
        // }
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: AppColors.primaryColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                widget.asset.typeFile?.toUpperCase() ?? '',
                maxLines: 1,
                style: textTheme.headlineSmall!.copyWith(
                  fontSize: 20,
                  color: AppColors.whiteColor,
                ),
              ),
              // if (!isDownloaded)
              //   if (progress == null || progress == 100)
              const Icon(
                AppIcons.arrowDownToLineCompact,
                color: AppColors.whiteColor,
              )
              // else
              //   CircularProgressIndicator(
              //     value: progress != null ? progress! / 100 : null,
              //     color: AppColors.whiteColor,
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
