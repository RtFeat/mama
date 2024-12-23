import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class PersonItem extends StatelessWidget {
  final AccountModel person;
  const PersonItem({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    // TODO добавить переход на информацию об пользователе
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          AvatarWidget(
            radius: 40,
            size: const Size(56, 56),
            url: person.avatarUrl,
          ),
          8.w,
          RichText(
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: person.name,
                  style: textTheme.bodyMedium,
                ),
                if (person.profession != null && person.profession!.isNotEmpty)
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: ProfessionBox(
                        profession: person.profession!,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
