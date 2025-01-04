import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class Header extends StatelessWidget {
  final MessageItem item;
  final bool isOnGroup;
  const Header({
    super.key,
    required this.item,
    required this.isOnGroup,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isOnGroup) ...[
          Expanded(
            child: Text(
              item.senderId ?? '',
              maxLines: 2,
              style: textTheme.titleSmall?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          //  if (person.profession != null && person.profession!.isNotEmpty)
          Padding(
              padding: const EdgeInsets.only(left: 3.0, bottom: 18),
              child: ConsultationBadge(
                title: 'sdf',
                // title: item.senderId.profession ?? '',
              )),
        ],
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
