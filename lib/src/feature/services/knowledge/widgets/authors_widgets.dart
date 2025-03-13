import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';
import 'package:mama/src/feature/services/knowledge/widgets/common_checkbox.dart';
import 'package:skit/skit.dart';

//TODO виджет нигде не используется, если не нужен удалить
class AuthorsSub extends StatelessWidget {
  final String title;
  final String titleAuthor;
  final int count;

  const AuthorsSub({
    super.key,
    required this.title,
    required this.count,
    required this.titleAuthor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(Assets.images.imgPerson2.path),
        ),
        10.w,
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontFamily: Assets.fonts.sFProTextRegular,
                fontWeight: FontWeight.w300,
              ),
            ),
            3.w,
            SizedBox(
              height: 14,
              width: 43,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.lightPurple,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  titleAuthor,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.blue,
                    fontFamily: Assets.fonts.sFProTextRegular,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            Text(
              count.toString(),
              style: const TextStyle(
                  color: AppColors.greyLighterColor, fontSize: 17),
            ),
            const CommonCheckBoxWidget(),
          ],
        ),
      ],
    );
  }
}

class SchoolSub extends StatelessWidget {
  final String title;
  final int count;

  const SchoolSub({
    super.key,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(Assets.images.imgPerson1.path),
        ),
        10.w,
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: Assets.fonts.sFProTextRegular,
                  fontWeight: FontWeight.w300,
                ),
              ),
              3.w,
            ],
          ),
        ),
        40.w,
        Row(
          children: [
            Text(
              count.toString(),
              style: const TextStyle(
                  color: AppColors.greyLighterColor, fontSize: 17),
            ),
            const CommonCheckBoxWidget(),
          ],
        ),
      ],
    );
  }
}
