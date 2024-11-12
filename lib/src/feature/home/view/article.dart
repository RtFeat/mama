import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class ArticleView extends StatelessWidget {
  final String? id;
  const ArticleView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Provider(
      create: (context) => NativeArticleStore(
          restClient: context.read<Dependencies>().restClient),
      builder: (context, _) {
        final NativeArticleStore store = context.watch();

        return Scaffold(
          body: Stack(
            children: [
              if (id != null)
                SafeArea(child: ArticleBody(id: id!, store: store)),
              Positioned(
                top: 50.0,
                left: 0.0,
                child: ButtonLeading(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 20.0,
                    color: AppColors.blackColor,
                  ),
                  title: t.profile.backLeadingButton,
                  labelStyle: textTheme.titleSmall,
                  onTapButton: () {
                    context.pop();
                  },
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(20),
                  ),
                ),
              ),
              Positioned(
                top: 50.0,
                right: 0.0,
                child: ButtonLeading(
                  iconAlignment: IconAlignment.end,
                  icon: IconWidget(
                      model: IconModel(
                    iconPath: Assets.icons.bookmark,
                  )),
                  title: t.home.toFavorites,
                  labelStyle: textTheme.titleSmall,
                  onTapButton: () {
                    if (id != null) {
                      store.addToFavorite(id!);
                    }
                    context.pop();
                  },
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
