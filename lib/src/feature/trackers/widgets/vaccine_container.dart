import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mama/src/core/core.dart';
import 'package:skit/skit.dart';

class VaccineContainer extends StatelessWidget {
  final String nameVaccine;
  final String recommendedAge;
  final String? recommendedAgeSubtitle;
  final VoidCallback? onTapAdd;
  final String? timeDate;
  final bool isDone;

  const VaccineContainer({
    super.key,
    required this.recommendedAge,
    this.recommendedAgeSubtitle,
    this.timeDate,
    required this.isDone,
    required this.nameVaccine,
    this.onTapAdd,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.whiteDarkerButtonColor,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: AutoSizeText(
                  nameVaccine,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 14,
                      ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// #rec age title
                    AutoSizeText(
                      recommendedAge,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 14,
                          ),
                    ),
                    5.h,

                    /// #rec age description
                    recommendedAgeSubtitle != null
                        ? AutoSizeText(
                            recommendedAgeSubtitle!,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(fontWeight: FontWeight.w400),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              isDone
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //TODO добавить еще иконку в шрифты
                          SvgPicture.asset(
                            Assets.images.done,
                          ),
                          AutoSizeText(
                            timeDate!,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontSize: 14,
                                ),
                          )
                        ],
                      ),
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: () => onTapAdd!(),
                          child: const Icon(
                            AppIcons.plus,
                            size: 30,
                            color: AppColors.greyColor,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
