import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class BodyEditFeedingBreastManually extends StatefulWidget {
  final String? formControlNameStart;
  final String? formControlNameEnd;
  final bool needIfEditNotCompleteMessage;
  final String? titleIfEditNotComplete;
  final String? textIfEditNotComplete;
  final Widget bodyWidget;

  final DateTime timerManualStart;
  final bool isTimerStart;
  final DateTime? timerManualEnd;
  final Function(String? value)? onStartTimeChanged;
  final Function(String? value)? onEndTimeChanged;
  final VoidCallback? onTapNotes;
  final VoidCallback? onTapConfirm;
  final Function() stopIfStarted;

  const BodyEditFeedingBreastManually({
    super.key,
    this.formControlNameStart,
    this.formControlNameEnd,
    required this.timerManualStart,
    this.timerManualEnd,
    this.onStartTimeChanged,
    this.onEndTimeChanged,
    this.onTapNotes,
    required this.onTapConfirm,
    required this.isTimerStart,
    this.titleIfEditNotComplete,
    this.textIfEditNotComplete,
    required this.bodyWidget,
    required this.stopIfStarted,
    required this.needIfEditNotCompleteMessage,
  });

  @override
  State<BodyEditFeedingBreastManually> createState() =>
      _BodyEditFeedingBreastManuallyState();
}

class _BodyEditFeedingBreastManuallyState extends State<BodyEditFeedingBreastManually> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    
    return Scaffold(
      backgroundColor: const Color(0xFFE7F2FE),
      appBar: CustomAppBar(
        height: 55,
        title: t.feeding.addManually,
        padding: const EdgeInsets.only(right: 8),
        titleTextStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: AppColors.trackerColor,
              fontSize: 17,
              letterSpacing: -0.5,
            ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.needIfEditNotCompleteMessage && widget.isTimerStart)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _HighlightedText(
                            text: widget.titleIfEditNotComplete ?? '',
                            highlight: 'кормление',
                          ),
                          8.h,
                          _HighlightedText(
                            text: widget.textIfEditNotComplete ?? '',
                            highlight: 'кормление',
                          ),
                          16.h,
                          CustomButton(
                            isSmall: false,
                            type: CustomButtonType.outline,
                            onTap: () {
                              context.pop();
                            },
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 12),
                            textStyle: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            title: t.trackers
                                .infoManuallyContainerButtonBackAndContinue,
                          ),
                          16.h,
                        ],
                      )
                    else
                      const SizedBox.shrink(),

                    // Bottom group pinned to screen bottom when content is short
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        widget.bodyWidget,
                        30.h,
                        EditTimeRow(
                          onTap: () {
                            if (widget.isTimerStart) {
                              widget.stopIfStarted();
                            }
                          },
                          timerStart: widget.timerManualStart,
                          timerEnd: widget.timerManualEnd,
                          isTimerStarted: widget.isTimerStart,
                          allowEditEndWhenTimerStarted: true,
                          onStartTimeChanged: (v) {
                            if (widget.onStartTimeChanged != null) {
                              widget.onStartTimeChanged!(v);
                            }
                          },
                          onEndTimeChanged: (v) {
                            if (widget.onEndTimeChanged != null) {
                              widget.onEndTimeChanged!(v);
                            }
                          },
                          formControlNameStart: widget.formControlNameStart!,
                          formControlNameEnd: widget.formControlNameEnd!,
                          cryStore: null,
                          sleepStore: null,
                        ),
                        32.h,
                        CustomButton(
                          height: 48,
                          width: double.infinity,
                          type: CustomButtonType.outline,
                          icon: AppIcons.pencil,
                          iconColor: AppColors.primaryColor,
                          title: t.feeding.note,
                          onTap: () {
                            if (widget.onTapNotes != null) {
                              widget.onTapNotes!();
                            }
                          },
                          iconSize: 28,
                        ),
                        8.h,
                        CustomButton(
                          backgroundColor: AppColors.greenLighterBackgroundColor,
                          height: 48,
                          width: double.infinity,
                          title: t.feeding.confirm,
                          onTap: widget.onTapConfirm,
                        ),
                        35.h,
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HighlightedText extends StatelessWidget {
  final String text;
  final String highlight;

  const _HighlightedText({required this.text, required this.highlight});

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(fontSize: 14, color: AppColors.greyBrighterColor) ??
        const TextStyle(fontSize: 14, color: Colors.grey);
    final TextStyle highlightStyle = baseStyle.copyWith(
      color: const Color(0xFF4D4DE8),
      fontWeight: FontWeight.w600,
      fontSize: 17,
    );

    final parts = text.split(highlight);
    if (parts.length == 1) {
      return Text(textAlign: TextAlign.center, text, style: baseStyle);
    }

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      runSpacing: 2,
      children: List<Widget>.generate(parts.length * 2 - 1, (index) {
        if (index.isEven) {
          final part = parts[index ~/ 2];
          return Text(part, style: baseStyle, textAlign: TextAlign.center);
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE1E6FF)),
            ),
            child: Text(highlight, style: highlightStyle),
          );
        }
      }),
    );
  }
}
