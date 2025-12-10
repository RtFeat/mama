import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class PhotoWidget extends StatelessWidget {
  final double? height;
  final String? photoUrl;
  final String? photoPath;
  final BorderRadius? borderRadius;
  const PhotoWidget(
      {super.key,
      this.height,
      this.photoUrl,
      this.photoPath,
      this.borderRadius})
      : assert(photoUrl != null || photoPath != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 390,
      decoration: BoxDecoration(
        borderRadius: borderRadius ??
            const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
        image: DecorationImage(
            filterQuality: FilterQuality.low,
            image: ResizeImage(
                (photoUrl != null
                    ? CachedNetworkImageProvider(photoUrl!, headers: {
                        'Authorization':
                            'Bearer ${context.read<ChatSocketFactory>().socket.accessToken}'
                      })
                    : FileImage(File(photoPath!)) as ImageProvider),
                height: 390),
            fit: BoxFit.cover),
      ),
    );
  }
}
