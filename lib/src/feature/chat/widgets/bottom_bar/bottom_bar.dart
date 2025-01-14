import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'bottom_bar_body.dart';

class ChatBottomBar extends StatelessWidget {
  const ChatBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
        color: AppColors.lightPirple,
        child: Provider(
          create: (context) => ChatBottomBarStore(store: context.read()),
          builder: (context, child) {
            final MessagesStore store = context.watch();

            return ReactiveForm(
              formGroup: store.formGroup,
              child: ChatBottomBarBody(
                barStore: context.watch(),
              ),
            );
          },
        ));
  }
}
