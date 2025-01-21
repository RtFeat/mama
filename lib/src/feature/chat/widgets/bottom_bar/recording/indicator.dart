import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class RecordingIndicator extends StatelessWidget {
  final Animation<double> animation;

  const RecordingIndicator({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    final ChatBottomBarStore store = context.watch();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            const SizedBox(width: 10),
            ScaleTransition(
                scale: animation,
                child: const SizedBox(
                  height: 10,
                  width: 10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.redBright,
                      shape: BoxShape.circle,
                    ),
                  ),
                )),
            const SizedBox(width: 10),
            Observer(
              builder: (_) =>
                  Text('${t.chat.recording} ${store.formattedDuration}'),
            ),
          ],
        ),
      ),
    );
  }
}
