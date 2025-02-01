import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

import 'category.dart';

class ArticleBox extends StatelessWidget {
  final ArticleModel model;

  const ArticleBox({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 200;
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppViews.article, extra: {'id': model.id});
      },
      child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.blackColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// #image, category
              Stack(
                children: [
                  /// #image
                  model.photo != null && model.photo!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: 16.r,
                          child: Image(
                            width: cardWidth,
                            height: 180,
                            fit: BoxFit.cover,
                            image: NetworkImage(model.photo!),
                          ),
                        )
                      : SizedBox(
                          width: cardWidth,
                          height: 180,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppColors.purpleLighterBackgroundColor,
                            ),
                            child: const Center(
                              child: Icon(Icons.image_not_supported_outlined),
                            ),
                          ),
                        ),

                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: cardWidth,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          if (model.category != null &&
                              model.category!.isNotEmpty)

                            /// #category
                            CategoryWidget(
                              title: model.category!,
                            ),
                          if (model.ageCategory != null &&
                              model.ageCategory!.isNotEmpty)
                            ...model.ageCategory!.map((e) {
                              return CategoryWidget(
                                title: switch (e) {
                                  AgeCategory.halfYear =>
                                    t.home.ageCategory.halfYear,
                                  AgeCategory.year => t.home.ageCategory.year,
                                  AgeCategory.twoYear =>
                                    t.home.ageCategory.twoYear,
                                  AgeCategory.older => t.home.ageCategory.older,
                                  _ => '',
                                },
                              );
                            }),
                        ],
                      ),
                    ),
                  )
                ],
              ),

              /// #article title
              Expanded(
                child: SizedBox(
                  width: 165,
                  child: Padding(
                    padding: const EdgeInsets.all(8).copyWith(top: 4),
                    child: AutoSizeText(
                      model.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
