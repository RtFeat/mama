import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mama/src/core/core.dart';

class PillContainer extends StatelessWidget {
  const PillContainer({
    super.key,
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
        child: Row(
          children: [
            /// #pill image
            const DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.purpleLighterBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: SizedBox(
                width: 120,
                height: 120,
                child: Center(
                  child: Icon(AppIcons.pillsFill),
                ),
              ),
            ),
            const SizedBox(width: 16),

            /// #pill details
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8).copyWith(right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// #pill title
                    AutoSizeText(
                      t.trackers.pillTitleOne.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// #pill description
                    AutoSizeText(
                      t.trackers.pillDescriptionOne.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // const SizedBox(height: 8),

                    /// #pill exact time, pill remaining time
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// #pill exact time
                        AutoSizeText(
                          t.trackers.pillExactTimeOne.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        /// #pill remaining time
                        AutoSizeText(
                          t.trackers.pillRemainingTimeOne.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
