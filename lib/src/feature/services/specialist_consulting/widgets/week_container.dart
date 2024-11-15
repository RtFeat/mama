import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/core.dart';

class WeekContainer extends StatelessWidget {
  const WeekContainer({super.key});

  @override
  Widget build(BuildContext context) {
    var weeks = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"];

    return Container(
      height: 64,
      decoration: BoxDecoration(
          color: AppColors.lightBlueBackgroundStatus,
          borderRadius: BorderRadius.circular(24)),
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _WeekBloc(
              week: weeks[index],
            );
          },
          separatorBuilder: (context, index) {
            return VerticalDivider(
              width: 2,
              color: Colors.white,
            );
          },
          itemCount: weeks.length),
    );
  }
}

class _WeekBloc extends StatefulWidget {
  final String week;

  const _WeekBloc({super.key, required this.week});

  @override
  State<_WeekBloc> createState() => _WeekBlocState();
}

class _WeekBlocState extends State<_WeekBloc> {
  var filled = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return Container(
      color: filled ? AppColors.primaryColor : Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            filled = !filled;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            children: [
              Text(
                widget.week,
                style: textTheme.bodyMedium?.copyWith(
                  color: filled ? Colors.white : AppColors.primaryColor
                ),
              ),
              filled ? Expanded(child: SvgPicture.asset(Assets.icons.icCheck)) : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
