import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'bottom_bar_body.dart';

class ChatBottomBar extends StatelessWidget {
  final MessagesStore store;
  const ChatBottomBar({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
        color: AppColors.lightPirple,
        child: Provider(
          create: (context) => ChatBottomBarStore(
            store: store,
            socket: context.read<ChatSocket>(),
            apiClient: context.read<Dependencies>().apiClient,
          ),
          builder: (context, child) {
            return ReactiveForm(
              formGroup: store.formGroup,
              child: ChatBottomBarBody(
                barStore: context.watch(),
                store: store,
              ),
            );
          },
        ));
  }
}
