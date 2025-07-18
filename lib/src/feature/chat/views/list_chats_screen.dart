import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class ChatsListScreen extends StatelessWidget {
  final PreferredSizeWidget appBar;
  const ChatsListScreen({
    super.key,
    required this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChatsViewStore>();

    return Scaffold(
      backgroundColor: AppColors.purpleLighterBackgroundColor,
      appBar: appBar,
      body: SubscribeBlockItem(child: Observer(builder: (context) {
        return ChatsBodyWidget(
          store: store,
          childId: context.watch<UserStore>().selectedChild?.id,
        );
      })),
    );
  }
}
