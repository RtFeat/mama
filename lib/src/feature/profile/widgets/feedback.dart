import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';

class FeedbackWidget extends StatefulWidget {
  final ProfileViewStore store;
  const FeedbackWidget({super.key, required this.store});

  @override
  State<FeedbackWidget> createState() => _FeedbackWidgetState();
}

class _FeedbackWidgetState extends State<FeedbackWidget> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autocorrect: true,
              autofocus: true,
              controller: controller,
              maxLines: 3,
              style:
                  textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        widget.store
                            .sendFeedback(controller.text)
                            .then((value) {
                          controller.clear();
                          if (context.mounted) {
                            context.pop();
                            DelightToastBar(
                              autoDismiss: true,
                              builder: (context) {
                                return ToastCard(
                                    title: Text(
                                  t.profile.feedback.success.desc,
                                  style: textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.normal),
                                ));
                              },
                            ).show(context);
                            // showDialog(
                            //     context: context,
                            //     builder: (context) {
                            //       return AlertDialog(
                            //         title: Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.center,
                            //           children: [
                            //             DecoratedBox(
                            //                 decoration: BoxDecoration(
                            //                   borderRadius: 4.r,
                            //                   color: AppColors
                            //                       .greenBrighterBackgroundColor,
                            //                 ),
                            //                 child: const Padding(
                            //                   padding: EdgeInsets.all(8.0),
                            //                   child: Icon(
                            //                     Icons.done,
                            //                     color: AppColors.whiteColor,
                            //                   ),
                            //                 )),
                            //           ],
                            //         ),
                            //         content: Column(
                            //           mainAxisSize: MainAxisSize.min,
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.center,
                            //           children: [
                            //             Text(
                            //               t.profile.feedback.success.desc,
                            //               style: textTheme.bodyMedium?.copyWith(
                            //                   fontWeight: FontWeight.normal),
                            //             ),
                            //             Text(
                            //               t.home.thanksForReachingOut,
                            //               textAlign: TextAlign.center,
                            //             ),
                            //           ],
                            //         ),
                            //         actions: [
                            //           TextButton(
                            //               onPressed: () {
                            //                 if (context.mounted) {
                            //                   context.pop();
                            //                 }
                            //               },
                            //               child: Text(
                            //                   t.profile.feedback.success.ok))
                            //         ],
                            //       );
                            //     });
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.purpleLighterBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                      child: Text(
                        t.profile.feedback.send,
                      )),
                ),
              ],
            ),
          ],
        ));
  }
}
