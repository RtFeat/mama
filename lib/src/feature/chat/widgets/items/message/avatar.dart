import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class MessageAvatar extends StatelessWidget {
  final bool isUser;
  final bool isOnGroup;
  final String? avatarUrl;
  const MessageAvatar(
      {super.key,
      required this.isUser,
      required this.isOnGroup,
      required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return AvatarWidget(url: avatarUrl, size: const Size(40, 40), radius: 20);
  }
}
