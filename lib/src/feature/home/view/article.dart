import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class ArticleView extends StatelessWidget {
  final String? id;
  const ArticleView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => NativeArticleStore(
          faker: context.read<Dependencies>().faker,
          id: id,
          apiClient: context.read<Dependencies>().apiClient),
      builder: (context, _) {
        final NativeArticleStore store = context.watch();

        return Scaffold(
            backgroundColor: Colors.white,
            body: _Body(
              store: store,
              id: id,
            ));
      },
    );
  }
}

class _Body extends StatefulWidget {
  final String? id;
  final NativeArticleStore store;
  const _Body({
    required this.store,
    required this.id,
  });

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  @override
  void initState() {
    widget.store.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return LoadingWidget(
        future: widget.store.fetchFuture,
        builder: (d) {
          return SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  if (widget.id != null)
                    ArticleBody(id: widget.id!, store: widget.store),
                  Positioned(
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
                    right: 0.0,
                    child: _FavoriteButton(id: widget.id),
                  ),
                ],
              ));
        });
  }
}

class _FavoriteButton extends StatelessWidget {
  final String? id;
  const _FavoriteButton({
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final NativeArticleStore store = context.watch();

    return Observer(builder: (context) {
      return ButtonLeading(
        iconAlignment: IconAlignment.end,
        icon: IconWidget(
            model: store.data?.isFavorite ?? false
                ? IconModel(
                    icon: AppIcons.bookmarkFill,
                  )
                : IconModel(
                    icon: AppIcons.bookmark,
                    color: AppColors.blackColor,
                  )),
        title: store.data?.isFavorite ?? false
            ? t.services.toSave.saved
            : t.services.toSave.title,
        labelStyle: textTheme.titleSmall,
        onTapButton: () {
          if (id != null) {
            store.toggleFavorite(id!);
          } else {
            context.pop();
          }
        },
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(20),
        ),
      );
    });
  }
}
