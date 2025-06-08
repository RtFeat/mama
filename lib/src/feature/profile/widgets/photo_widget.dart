import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class ProfilePhoto extends StatelessWidget {
  final String? photoUrl;
  final Function()? onIconTap;
  final Widget? icon;
  final double? height;
  final bool isShowIcon;
  final BorderRadius? borderRadius;
  final Function()? onDeleteTap;
  const ProfilePhoto({
    super.key,
    this.photoUrl,
    this.onIconTap,
    this.icon,
    this.isShowIcon = true,
    this.height,
    this.borderRadius,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final UserStore userStore = context.watch();
    final ImagePicker picker = context.watch<Dependencies>().imagePicker;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Observer(builder: (_) {
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
                            NetworkImage(
                              photoUrl ?? userStore.account.avatarUrl ?? '',
                            ),
                            height: 390),
                        fit: BoxFit.cover),
                  ),
                );
              }),
            ],
          ),
        ),
        if (onDeleteTap != null)
          Positioned.fill(
              // bottom: -32,
              left: 32,
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: RawMaterialButton(
                    shape: const CircleBorder(),
                    fillColor: AppColors.redColor,
                    padding: const EdgeInsets.all(20),
                    onPressed: () {
                      onDeleteTap?.call();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.delete,
                        size: 32,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ))),
        if (isShowIcon)
          Positioned.fill(
            // bottom: -32,
            right: 32,
            child: Align(
              alignment: Alignment.bottomRight,
              child: RawMaterialButton(
                shape: const CircleBorder(),
                fillColor: AppColors.primaryColor,
                padding: const EdgeInsets.all(20),
                onPressed: onIconTap ??
                    () async {
                      await picker
                          .pickImage(source: ImageSource.gallery)
                          .then((value) {
                        if (value != null) {
                          userStore.updateAvatar(value);
                        }
                      });
                    },
                child: icon ??
                    const Icon(
                      AppIcons.cameraOnRectangleFill,
                      size: 32,
                      color: AppColors.whiteColor,
                    ),
              ),
            ),
          ),
      ],
    );
  }
}

class DashedPhotoProfile extends StatelessWidget {
  final VoidCallback? onIconTap;
  final Color? backgroundColor;
  final double? height;
  final double? width;
  final double? iconHeight;
  final bool? needText;
  final String? text;
  final BorderRadius? borderRadius;
  final double? radius;
  const DashedPhotoProfile(
      {super.key,
      this.onIconTap,
      this.height,
      this.width,
      this.text,
      this.borderRadius,
      this.needText = true,
      this.iconHeight,
      this.radius,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final UserStore userStore = context.watch();
    return GestureDetector(
      onTap: onIconTap ??
          () {
            final ImagePicker picker = ImagePicker();

            picker.pickImage(source: ImageSource.gallery).then((value) {
              if (value != null) {
                userStore.updateAvatar(value);
              }
            });
          },
      child: Container(
        height: height ?? 390,
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.purpleLighterBackgroundColor,
          borderRadius: borderRadius ??
              BorderRadius.only(
                bottomLeft: Radius.circular(radius ?? 32),
                bottomRight: Radius.circular(radius ?? 32),
              ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 1.0, left: 1.0, right: 1.0),
          child: DottedBorder(
            strokeWidth: 1.5,
            color: AppColors.primaryColor,
            borderType: BorderType.RRect,
            dashPattern: const [10, 7],
            radius: Radius.circular(radius ?? 32),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    AppIcons.cameraOnRectangle,
                    size: iconHeight ?? 53,
                    color: AppColors.primaryColor,
                  ),
                  needText!
                      ? Text(text ?? t.profile.addPhotoTitle,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(fontWeight: FontWeight.w400))
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
