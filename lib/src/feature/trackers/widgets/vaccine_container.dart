import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mama/src/core/core.dart';
import 'package:skit/skit.dart';

class VaccineContainer extends StatelessWidget {
  final EntityVaccinationMain model;

  const VaccineContainer({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.whiteDarkerButtonColor,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          model.name ?? '',
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontSize: 14,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                6.w,
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// #rec age title
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              model.age ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    fontSize: 14,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      5.h,

                      /// #rec age description
                      model.ageDescription != null &&
                              model.ageDescription!.isNotEmpty
                          ? AutoSizeText(
                              model.ageDescription!,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(fontWeight: FontWeight.w400),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                6.w,
                Expanded(
                  flex: 4,
                  child: Observer(builder: (context) {
                    return model.mark != null && model.mark!.isNotEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //TODO добавить еще иконку в шрифты
                                  SvgPicture.asset(
                                    Assets.images.done,
                                  ),
                                  Text(
                                    model.mark ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          fontSize: 14,
                                        ),
                                  ),
                                  Text(model.markDescription ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!)
                                ],
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(
                                flex: 2,
                              ),
                              const Icon(
                                AppIcons.plus,
                                size: 30,
                                color: AppColors.greyColor,
                              ),
                              Spacer(),
                            ],
                          );
                  }),
                ),
              ],
            )));
  }
}
