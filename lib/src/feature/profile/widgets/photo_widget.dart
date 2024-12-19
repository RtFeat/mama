import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class PhotoWidget extends StatelessWidget {
  const PhotoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final UserStore userStore = context.watch();

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Observer(builder: (_) {
          return Container(
            height: 390,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              image: DecorationImage(
                  image: NetworkImage(
                    userStore.account.avatarUrl!,
                  ),
                  fit: BoxFit.cover),
            ),
          );
        }),
        Positioned.fill(
          bottom: -32,
          right: 32,
          child: Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Image.asset(
                Assets.icons.icPhotoAdd.path,
                height: 64,
              ),
              onPressed: () {
                final ImagePicker picker = ImagePicker();

                picker.pickImage(source: ImageSource.gallery).then((value) {
                  if (value != null) {
                    userStore.updateAvatar(value);
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class DashedPhotoProfile extends StatelessWidget {
  const DashedPhotoProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 390,
      decoration: const BoxDecoration(
        color: AppColors.purpleLighterBackgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 1.0, left: 1.0, right: 1.0),
        child: DottedBorder(
          strokeWidth: 1.5,
          color: AppColors.primaryColor,
          borderType: BorderType.RRect,
          dashPattern: const [10, 7],
          radius: const Radius.circular(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  height: 64,
                  image: AssetImage(
                    Assets.icons.icPhotoAdd.path,
                  ),
                ),
                Text(t.profile.addPhotoTitle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
