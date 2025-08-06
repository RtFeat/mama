import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class VisitPhotoWidget extends StatefulWidget {
  final AddDoctorVisitViewStore store;
  const VisitPhotoWidget({super.key, required this.store});

  @override
  State<VisitPhotoWidget> createState() => _VisitPhotoWidgetState();
}

class _VisitPhotoWidgetState extends State<VisitPhotoWidget> {
  PageController? controller;

  @override
  void initState() {
    controller = PageController();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return widget.store.imagesUrls?.isEmpty ?? widget.store.images.isEmpty
          ? SelectPhotoWidget(onTap: widget.store.pickImage)
          : _FewPhotosWidget(controller: controller, store: widget.store);
    });
  }
}

class _FewPhotosWidget extends StatelessWidget {
  const _FewPhotosWidget({
    required this.controller,
    required this.store,
  });

  final AddDoctorVisitViewStore store;
  final PageController? controller;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width - 88,
                child: PageView.builder(
                  controller: controller,
                  itemCount: store.imagesUrls?.length ?? store.images.length,
                  itemBuilder: (_, index) {
                    return PhotoWidget(
                      photoUrl: store.imagesUrls != null &&
                              store.imagesUrls!.isNotEmpty
                          ? store.imagesUrls![index]
                          : null,
                      photoPath: store.images.isNotEmpty
                          ? store.images[index].path
                          : null,
                      height: 200,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                    );
                  },
                ),
              ),
              if (((store.imagesUrls?.length ?? 0) > 1) ||
                  store.images.length > 1) ...[
                8.h,
                SmoothPageIndicator(
                  controller: controller!,
                  count: store.imagesUrls?.length ?? store.images.length,
                  effect: CustomizableEffect(
                    activeDotDecoration: DotDecoration(
                      width: 24,
                      height: 8,
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    dotDecoration: DotDecoration(
                      width: 8,
                      height: 8,
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(16),
                      verticalOffset: 0,
                    ),
                    spacing: 4.0,
                  ),
                ),
              ]
            ],
          ),
          8.w,
          Column(
            children: [
              DashedPhotoProfile(
                backgroundColor: AppColors.primaryColorBright,
                onIconTap: () async {
                  await store.pickImage();
                },
                height: 200,
                width: 48,
                iconHeight: 26,
                needText: false,
                text: t.trackers.addPhoto,
                borderRadius: const BorderRadius.all(
                  Radius.circular(2),
                ),
                radius: 16,
              ),
            ],
          )
        ],
      );
    });
  }
}
