import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class DrugPhoto extends StatelessWidget {
  const DrugPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    final AddDrugsViewStore store = context.watch<AddDrugsViewStore>();

    return Observer(builder: (context) {
      return store.image != null ||
              (store.model?.imageId != null &&
                  (store.model?.imageId!.isNotEmpty ?? false))
          ? GestureDetector(
              onTap: store.pickImage,
              child: PhotoWidget(
                height: 358,
                borderRadius: BorderRadius.circular(16),
                photoUrl: store.model?.imageId != null &&
                        (store.model?.imageId!.isNotEmpty ?? false)
                    ? store.model?.imageId
                    : null,
                photoPath: store.image != null && store.image!.path.isNotEmpty
                    ? store.image?.path
                    : null,
              ),
            )
          : SelectPhotoWidget(
              height: 358,
              onTap: store.pickImage,
            );
    });
  }
}
