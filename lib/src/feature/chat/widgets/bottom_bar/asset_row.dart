import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class AssetsInBottomWidget extends StatelessWidget {
  final VoidCallback? onTapDelete;
  final EdgeInsets? padding;
  final double? height;

  const AssetsInBottomWidget({
    super.key,
    this.onTapDelete,
    this.padding,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final ChatBottomBarStore barStore = context.watch();

    return Observer(builder: (context) {
      return SizedBox(
        height: height ?? 100,
        child: ListView.builder(
          itemCount: barStore.files.length,
          padding: padding ?? const EdgeInsets.all(10),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            PlatformFile file = barStore.files[index];

            return AssetItemWidget(
              asset: MessageFile(
                  typeFile: file.extension.toString(),
                  fileUrl: file.path.toString(),
                  filename: file.name),
              onTapDelete: () {
                barStore.files.remove(file);
                onTapDelete?.call();
              },
            );
          },
        ),
      );
    });
  }
}
