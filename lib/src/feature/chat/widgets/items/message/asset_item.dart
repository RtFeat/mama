import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mama/src/data.dart';
import 'package:open_filex/open_filex.dart';
import 'package:skit/skit.dart';

class AssetItemWidget extends StatelessWidget {
  final MessageFile asset;
  final bool isCanDelete;
  final VoidCallback onTapDelete;
  const AssetItemWidget(
      {super.key,
      required this.asset,
      required this.onTapDelete,
      this.isCanDelete = false});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    const double size = 64;

    return SizedBox(
      width: size,
      child:
          // _Body(asset: asset),
          isCanDelete
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      clipBehavior: Clip.none,
                      children: [
                        _Body(asset: asset),
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
                )
              : _Body(asset: asset),
    );
  }
}

class _Body extends StatelessWidget {
  final MessageFile asset;
  const _Body({
    required this.asset,
  });

  @override
  Widget build(BuildContext context) {
    const double size = 64;
    return GestureDetector(
        onTap: () async {
          var file = await DefaultCacheManager().getSingleFile(
              '${const AppConfig().apiUrl}chat/message/file/${asset.fileUrl!}.${asset.typeFile}');
          OpenFilex.open(file.path);
        },
        child: _Asset(asset: asset, size: size));
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
                    memCacheWidth: size.toInt() * 2,
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

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: AppColors.primaryColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
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
    );
  }
}
