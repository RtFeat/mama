import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class ChatsListScreen extends StatefulWidget {
  final CustomAppBar appBar;
  const ChatsListScreen({
    super.key,
    required this.appBar,
  });

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => ChatsViewStore(
        restClient: context.read<Dependencies>().restClient,
      ),
      builder: (context, _) {
        final store = context.watch<ChatsViewStore>();

        return Scaffold(
          backgroundColor: AppColors.purpleLighterBackgroundColor,
          appBar: widget.appBar,
          body: SubscribeBlockItem(
              child: ChatsBodyWidget(
            store: store,
            childId: context.watch<UserStore>().selectedChild?.id,
          )),
        );
      },
    );
  }
}
