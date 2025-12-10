import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class Header extends StatelessWidget {
  final MessageItem item;
  final bool isOnGroup;
  final bool isUser;
  const Header({
    super.key,
    required this.isUser,
    required this.item,
    required this.isOnGroup,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (isOnGroup && !isUser)
          Expanded(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Flexible(
                    child: Text(
                      '${item.senderName} ${item.senderSurname != null && item.senderSurname!.isNotEmpty ? '${item.senderSurname}' : ''}',
                      maxLines: 2,
                      style: textTheme.titleSmall?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (item.senderProfession != null &&
                      item.senderProfession!.isNotEmpty &&
                      item.senderProfession != 'USER')
                    Padding(
                        padding: const EdgeInsets.only(left: 3.0, bottom: 18),
                        child: ConsultationBadge(
                          title: item.senderProfession!,
                          // title: item.senderId.profession ?? '',
                        )),
                ]),
          ),
        10.w,
        Text(
          item.createdAt?.formattedTime ?? '',
          style: textTheme.bodySmall?.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColors.greyColor,
          ),
        ),
      ],
    );
  }
}
