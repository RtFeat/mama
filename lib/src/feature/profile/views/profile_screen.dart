import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final VerifyStore verifyStore = context.watch();
    final ChildStore childStore = context.watch();
    final UserStore userStore = context.watch();
    final SchoolStore schoolStore = context.watch();
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    final TextStyle? titlesStyle = textTheme.bodyMedium;
    final TextStyle? titlesColoredStyle = textTheme.labelLarge?.copyWith(
      fontSize: 17,
      fontWeight: FontWeight.w600,
    );

    List<DialogItem> alertDialog = [
      DialogItem(
          title: 'Сбросить настройки?',
          subtitle:
              'Если сейчас выйти из аккаунта, не сохраненные данные потеряются',
          onTap: () {}),
      DialogItem(
          title: 'Сбросить настройки?',
          subtitle:
              'Если сейчас выйти из аккаунта, не сохраненные данные потеряются',
          text: 'Заполните обязательные поля, чтобы сохранить данные ребенка',
          onTap: () {})
    ];

    return Provider(
        create: (context) => ProfileViewStore(
            model: userStore.account,
            restClient: context.read<Dependencies>().restClient),
        builder: (context, _) {
          final ProfileViewStore store = context.watch();

          return Scaffold(
            extendBodyBehindAppBar: true,
            body: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.gradientPurpleBackgroundScaffold,
                    AppColors.gradientPurpleLighterBackgroundScaffold,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Observer(builder: (_) {
                        return MomsProfile(
                          homeStore: context.watch(),
                          titlesStyle: titlesStyle,
                          titlesColoredStyle: titlesColoredStyle,
                          schoolId: schoolStore.data?.id,
                          accountModel: userStore.account,
                          store: store,
                          formatter: MaskTextInputFormatter(
                              mask: '+# ### ###-##-##',
                              filter: {'#': RegExp(r'[0-9]')}),
                        );
                      }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {
                                context.pushNamed(AppViews.pdfView, extra: {
                                  'path': Assets
                                      .docs.consentToProcessPersonalDataMP,
                                });
                              },
                              child: Text(
                                t.profile.aboutCompanyTitle,
                                style: titlesColoredStyle,
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {
                                context.pushNamed(AppViews.docs);
                              },
                              child: Text(
                                t.profile.termOfUseTitle,
                                style: titlesColoredStyle,
                              )),
                        ],
                      ),
                      16.h,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: CustomButton(
                          title: t.profile.feedbackButtonTitle,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    contentPadding: const EdgeInsets.all(10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    title: Center(
                                        child: Text(
                                      t.profile.feedback.title,
                                      style: textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w700),
                                    )),
                                    content: FeedbackWidget(
                                      store: store,
                                    ),
                                  );
                                });
                          },
                          icon: IconModel(
                            icon: Icons.language,
                          ),
                        ),
                      ),
                      8.h,
                      if (userStore.account.role == Role.doctor) ...[
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: CustomButton(
                              onTap: () {
                                context.pushNamed(AppViews.webView, extra: {
                                  'url': 'https://google.com',
                                });
                              },
                              isSmall: false,
                              icon: IconModel(
                                icon: Icons.language,
                              ),
                              title: t.profile.settingsAccountButtonTitle,
                            )),
                        8.h,
                      ],
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: CustomButton(
                          onTap: () async {
                            // await showDialog(
                            //   context: context,
                            //   builder: (context) => Dialog(
                            //     insetPadding: const EdgeInsets.all(8.0),
                            //     child: DialogWidget(
                            //       errorDialog: true,
                            //       item: alertDialog[0],
                            //       onTapExit: () {
                            //         context.pop();
                            //         verifyStore.logout();
                            //       },
                            //       onTapContinue: () {
                            //         context.pop();
                            //       },
                            //     ),
                            //   ),
                            // );
                            verifyStore.logout();
                          },
                          backgroundColor: AppColors.redLighterBackgroundColor,
                          title: t.profile.leaveAccountButtonTitle,
                          textStyle: textTheme.titleMedium!.copyWith(
                            color: AppColors.redColor,
                          ),
                        ),
                      ),
                      32.h,
                    ],
                  ),
                  //   ),
                  // ],
                  // ),
                  Positioned(
                    top: 50.0,
                    left: 0.0,
                    child: ButtonLeading(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 20.0,
                        color: AppColors.blackColor,
                      ),
                      title: t.profile.backLeadingButton,
                      labelStyle:
                          titlesStyle!.copyWith(fontWeight: FontWeight.w400),
                      onTapButton: () async {
                        if (userStore.account.isChanged ||
                            userStore.changedDataOfChild.isNotEmpty) {
                          await showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              insetPadding: const EdgeInsets.all(8.0),
                              child: DialogWidget(
                                errorDialog: true,
                                item: alertDialog[0],
                                onTapExit: () {
                                  context.pop();
                                  context.pop();
                                  userStore.account.setIsChanged(false);

                                  for (var e in userStore.changedDataOfChild) {
                                    e.setIsChanged(false);
                                  }
                                },
                                onTapContinue: () {
                                  context.pop();
                                  FocusScope.of(context).unfocus();
                                },
                              ),
                            ),
                          );
                        } else {
                          context.pop();
                        }
                        // store.formGroup.updateValue({});
                      },
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(20),
                      ),
                    ),
                  ),

                  Observer(builder: (context) {
                    if (userStore.account.isChanged ||
                        userStore.changedDataOfChild.isNotEmpty) {
                      return Positioned(
                        top: 50.0,
                        right: 0.0,
                        child: ButtonLeading(
                          icon: const SizedBox.shrink(),
                          title: t.profile.save,
                          labelStyle:
                              titlesStyle.copyWith(fontWeight: FontWeight.w400),
                          onTapButton: () {
                            store.updateData();
                            userStore.updateData(
                                city: userStore.user.city,
                                firstName: userStore.account.firstName,
                                secondName: userStore.account.secondName,
                                email: userStore.account.email,
                                profession: userStore.account.profession,
                                info: userStore.account.info);

                            if (userStore.changedDataOfChild.isNotEmpty) {
                              for (var e in userStore.changedDataOfChild) {
                                childStore.update(model: e);
                              }
                            }

                            FocusScope.of(context).unfocus();
                          },
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(20),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          );
        });
  }
}
