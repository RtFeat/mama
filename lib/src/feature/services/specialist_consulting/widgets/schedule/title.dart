import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class SpecialistScheduleTitleWidget extends StatelessWidget {
  const SpecialistScheduleTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    final ScheduleViewStore store = context.watch();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Text(
            "Базовая сетка",
            style: textTheme.titleLarge
                ?.copyWith(color: Colors.black, fontSize: 20),
          ),
          const Spacer(),
          Observer(builder: (_) {
            return TextButton(
                onPressed: () {
                  store.toggleCollapsed();
                },
                child: Row(
                  children: [
                    IconWidget(
                        model: IconModel(
                      icon: store.isCollapsed
                          ? AppIcons.chevronDown
                          : AppIcons.chevronUp,
                      // iconPath: store.isCollapsed
                      //     ? Assets.icons.chevronDown
                      //     : Assets.icons.chevronUp
                    )),
                    Text(
                      store.isCollapsed ? "Развернуть" : "Свернуть",
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    )
                  ],
                ));
          })
        ],
      ),
    );
  }
}
