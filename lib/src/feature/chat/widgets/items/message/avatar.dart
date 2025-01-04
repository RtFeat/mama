import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class MessageAvatar extends StatelessWidget {
  final bool isUser;
  final bool isOnGroup;
  const MessageAvatar(
      {super.key, required this.isUser, required this.isOnGroup});

  @override
  Widget build(BuildContext context) {
    return !isUser
        ? isOnGroup
            ? const AvatarWidget(url: null, size: Size(40, 40), radius: 20)
            : const SizedBox.shrink()
        : const Spacer();
  }
}
