import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:substring_highlight/substring_highlight.dart';

class PersonItem extends StatelessWidget {
  final GroupUsersStore? store;
  final AccountModel person;
  const PersonItem({super.key, required this.store, required this.person});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          context.pushNamed(AppViews.profileInfo, extra: {
            'model': person,
          });
        },
        child: Row(
          children: [
            AvatarWidget(
              radius: 40,
              size: const Size(56, 56),
              url: person.avatarUrl,
            ),
            8.w,
            SubstringHighlight(
              text: person.name,
              textStyle: textTheme.bodyMedium!,
              maxLines: 2,
              term: store?.query ?? '',
              textStyleHighlight: textTheme.bodyMedium!.copyWith(
                  backgroundColor: AppColors.lightBlueBackgroundStatus),
            ),
            if (person.profession != null && person.profession!.isNotEmpty)
              Padding(
                  padding: const EdgeInsets.only(left: 3.0, bottom: 18),
                  child: ConsultationBadge(
                    title: person.profession ?? '',
                  )),
          ],
        ),
      ),
    );
  }
}
