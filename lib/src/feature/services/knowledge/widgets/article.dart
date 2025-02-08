import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

import '../../../home/widgets/category.dart';

class ArticleWidget extends StatelessWidget {
  final ArticleModel? article;
  final FavoriteArticle? favoriteArticle;
  final FavoriteArticlesStore? store;
  const ArticleWidget(
      {super.key, this.store, this.article, this.favoriteArticle})
      : assert(article != null || favoriteArticle != null);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return GestureDetector(
      onTap: () {
        context.pushNamed(AppViews.article, extra: {
          'id': favoriteArticle?.id ?? article!.id,
          'store': store,
        });
      },
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.lightBlue,
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: Row(
                            children: [
                              AvatarWidget(
                                  url: favoriteArticle?.avatarUrl ??
                                      article!.author?.avatarUrl,
                                  size: const Size(50, 50),
                                  radius: 100),
                              8.w,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    favoriteArticle?.author ??
                                        article?.author?.name ??
                                        '',
                                    style: textTheme.labelMedium?.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),
                                  if ((favoriteArticle?.profession != null &&
                                          (favoriteArticle
                                                  ?.profession?.isNotEmpty ??
                                              false)) ||
                                      (article?.author?.profession != null &&
                                          (article?.author?.profession
                                                  ?.isNotEmpty ??
                                              false)))
                                    ConsultationBadge(
                                      title: favoriteArticle?.profession ??
                                          article?.author!.profession ??
                                          '',
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        8.h,
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                favoriteArticle?.title ?? article?.title ?? '',
                                style: textTheme.headlineSmall?.copyWith(
                                  fontSize: 20,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        if (favoriteArticle?.ageCategory != null ||
                            article?.tags != null) ...[
                          8.h,
                          Row(
                            children: [
                              Expanded(
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: favoriteArticle?.ageCategory != null
                                      ? favoriteArticle!.ageCategory!.map((e) {
                                          return CategoryWidget(
                                            title: switch (e) {
                                              AgeCategory.halfYear =>
                                                t.home.ageCategory.halfYear,
                                              AgeCategory.year =>
                                                t.home.ageCategory.year,
                                              AgeCategory.twoYear =>
                                                t.home.ageCategory.twoYear,
                                              AgeCategory.older =>
                                                t.home.ageCategory.older,
                                              _ => '',
                                            },
                                          );
                                        }).toList()
                                      : article!.tags!.map((e) {
                                          return Chip(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            color: const WidgetStatePropertyAll(
                                                AppColors
                                                    .whiteDarkerButtonColor),
                                            label: Text(
                                              e,
                                              style: textTheme.labelSmall
                                                  ?.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            visualDensity:
                                                VisualDensity.compact,
                                            side: BorderSide.none,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          );
                                        }).toList(),
                                ),
                              ),
                            ],
                          )
                        ]
                      ],
                    ),
                  )),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: AvatarWidget(
                    url: favoriteArticle?.articlePhotoUrl ?? article?.photo,
                    size: const Size(100, 100),
                    radius: 24,
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
