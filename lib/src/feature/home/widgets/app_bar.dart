import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onTapSwitch;
  final Widget? action;

  const HomeAppBar({
    super.key,
    this.onTapSwitch,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final userStore = context.watch<UserStore>();

    return CustomAppBar(
      leading: _ProfileLeading(userStore: userStore),
      action: action ?? _ProfileAction(onTapSwitch: onTapSwitch),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ProfileLeading extends StatelessWidget {
  final UserStore userStore;

  const _ProfileLeading({required this.userStore});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => ProfileWidget(
        onTap: () => router.pushNamed(AppViews.profile),
        alignment: Alignment.centerLeft,
        avatarUrl: userStore.account.avatarUrl ?? '',
      ),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  final VoidCallback? onTapSwitch;

  const _ProfileAction({this.onTapSwitch});

  @override
  Widget build(BuildContext context) {
    return ProfileWidget(
      isShowText: true,
      onTapSwitch: onTapSwitch,
    );
  }
}
