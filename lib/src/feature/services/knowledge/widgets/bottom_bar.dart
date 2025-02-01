import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class FilterBottomBarWidget extends StatelessWidget {
  final Function() onClear;
  final Function() onConfirm;
  const FilterBottomBarWidget(
      {super.key, required this.onClear, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  title: t.services.clear,
                  isSmall: false,
                  maxLines: 1,
                  onTap: () {
                    onClear();
                  },
                  backgroundColor: AppColors.redLighterBackgroundColor,
                ),
              ),
              10.w,
              Expanded(
                  flex: 2,
                  child: CustomButton(
                    title: t.auth.confirm,
                    maxLines: 1,
                    isSmall: false,
                    onTap: () {
                      onConfirm();
                      context.pop();
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
