import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/core/widgets/body/decoration.dart';
import 'package:mama/src/data.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class MomsProfile extends StatefulWidget {
  final ProfileViewStore store;
  final MaskTextInputFormatter formatter;
  final AccountModel accountModel;

  final String? schoolId;

  final TextStyle? titlesStyle;
  final TextStyle? helpersStyle;
  final TextStyle? titlesColoredStyle;

  final HomeViewStore? homeStore;

  const MomsProfile({
    super.key,
    required this.store,
    this.schoolId,
    this.titlesStyle,
    this.helpersStyle,
    this.titlesColoredStyle,
    required this.accountModel,
    required this.formatter,
    this.homeStore,
  });

  @override
  State<MomsProfile> createState() => _MomsProfileState();
}

class _MomsProfileState extends State<MomsProfile> {
  @override
  void initState() {
    widget.store.init();
    if (widget.accountModel.role == Role.onlineSchool) {
      widget.homeStore?.loadSchoolCourses(widget.schoolId!);
    }
    super.initState();
  }

  @override
  void dispose() {
    widget.store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final UserStore userStore = context.watch();

    final BodyItemWidget aboutMe = BodyItemWidget(
      item: InputItem(
        errorBorder: InputBorder.none,
        controlName: 'about',
        hintText: t.profile.hintChangeNote,
        titleStyle: widget.titlesStyle!,
        inputHint: t.profile.labelChangeNote,
        inputHintStyle: textTheme.bodySmall,
        onChanged: (value) {
          userStore.account.setIsChanged(true);
          // widget.store.updateData();
        },
      ),
    );

    return Observer(builder: (context) {
      return Column(
        children: [
          widget.accountModel.avatarUrl == null
              ? const DashedPhotoProfile()
              : const ProfilePhoto(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.h,
                BodyGroup(
                  formGroup: widget.store.formGroup,
                  title: switch (userStore.account.role) {
                    Role.doctor => t.profile.accountTitleSpecialist,
                    Role.onlineSchool => t.profile.accountTitleSchool,
                    _ => t.profile.accountTitle,
                  },
                  items: [
                    BodyItemWidget(
                      item: InputItem(
                        controlName: 'name',
                        hintText: t.profile.hintChangeName,
                        titleStyle: textTheme.headlineSmall,
                        maxLines: 1,
                        onChanged: (value) {
                          userStore.account.setIsChanged(true);
                          // widget.store.updateData();
                        },
                      ),
                    ),
                    if (userStore.account.role == Role.doctor)
                      BodyItemWidget(
                        item: InputItem(
                          controlName: 'profession',
                          hintText: t.profile.helperProfession,
                          titleStyle: widget.titlesStyle!.copyWith(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w400),
                          inputHintStyle: textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          onChanged: (value) {
                            userStore.account.setIsChanged(true);
                            // widget.store.updateData();
                          },
                        ),
                      ),
                    if (userStore.account.role == Role.doctor)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  t.profile.titleNameProffession,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: textTheme.labelLarge,
                                ),
                              ],
                            ),
                            6.h,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    '${userStore.account.firstName} ${userStore.account.secondName}',
                                    style: textTheme.displaySmall?.copyWith(
                                      fontSize: 24,
                                    ),
                                    maxLines: 1),
                                if (userStore.account.profession != null &&
                                    userStore.account.profession!.isNotEmpty)
                                  ConsultationBadge(
                                    title: userStore.account.profession ?? '',
                                  )
                              ],
                            ),
                          ],
                        ),
                      ),
                    BodyItemWidget(
                      item: InputItem(
                        controlName: 'phone',
                        hintText: userStore.role == Role.user
                            ? t.profile.hintChangePhone
                            : t.profile.hintChangePhoneSchool,
                        titleStyle: widget.titlesStyle!.copyWith(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w400),
                        inputHintStyle: textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        inputHint: '+7 996 997-06-24',
                        maxLines: 1,
                        maskFormatter: widget.formatter,
                        onChanged: (value) {
                          userStore.account.setIsChanged(true);
                          // widget.store.updateData();
                        },
                      ),
                    ),
                    ReactiveFormConsumer(builder: (context, form, _) {
                      final email = form.control('email');
                      final bool isEmpty =
                          email.value == null || email.value == '';
                      return BodyItemWidget(
                        item: InputItem(
                          errorBorder: InputBorder.none,
                          controlName: 'email',
                          maxLines: isEmpty ? 2 : 1,
                          hintText: userStore.role == Role.user
                              ? t.profile.hintChangeEmail
                              : t.profile.hintChangeEmailSchool,
                          keyboardType: TextInputType.emailAddress,
                          inputHintStyle: textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                          inputHint: t.profile.labelChangeEmail,
                          onChanged: (value) {
                            userStore.account.setIsChanged(true);
                            // widget.store.updateData();
                          },
                        ),
                      );
                    }),
                    switch (userStore.account.role) {
                      Role.onlineSchool || Role.doctor => Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: BodyGroup(
                              title: t.profile.titleInfo,
                              formGroup: widget.store.formGroup,
                              items: [aboutMe]),
                        ),
                      _ => aboutMe,
                    }
                  ],
                ),
                26.h,
                if (userStore.role == Role.user)
                  CustomButton(
                    isSmall: false,
                    onTap: () {
                      context.pushNamed(AppViews.promoView);
                    },
                    title: t.profile.addGiftCodeButtonTitle,
                  ),
                8.h,
                if (userStore.role != Role.doctor)
                  CustomButton(
                    onTap: () {
                      context.pushNamed(AppViews.webView, extra: {
                        'url': 'https://google.com',
                      });
                    },
                    isSmall: false,
                    // icon: IconModel(
                    //   icon: Icons.language,
                    // ),
                    icon: AppIcons.globe,
                    title: t.profile.settingsAccountButtonTitle,
                  ),
                30.h,
                SubscribeBlockItem(child: Observer(builder: (_) {
                  return IgnorePointer(
                      ignoring: !userStore.isPro,
                      child: ChildItems(
                        childs: userStore.children.toList(),
                      ));
                })),
                if (userStore.role == Role.onlineSchool)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: BodyGroup(title: t.profile.titleCourses, items: [
                      PaginatedLoadingWidget(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          store: widget.homeStore!.coursesStore,
                          itemBuilder: (_, data) => SizedBox(
                              height: 120,
                              child: BodyItemDecoration(
                                  borderRadius: 32.r,
                                  padding: const EdgeInsets.only(left: 10),
                                  child: BodyItemWidget(
                                      item: CustomBodyItem(
                                          bodyAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          title: data.title ?? '',
                                          titleStyle:
                                              textTheme.headlineSmall?.copyWith(
                                            fontSize: 20,
                                          ),
                                          subTitleLines: 2,
                                          hintStyle: textTheme.titleSmall,
                                          subTitle: data.shortDescription ?? '',
                                          subTitleWidth: double.infinity,
                                          body: GestureDetector(
                                            onTap: () {
                                              context.pushNamed(
                                                  AppViews.webView,
                                                  extra: {
                                                    'url': data.link ??
                                                        'https://google.com',
                                                  });
                                            },
                                            child: SizedBox(
                                              width: 70,
                                              child: DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    color: AppColors
                                                        .lightBlueBackgroundStatus,
                                                    borderRadius: 32.r,
                                                  ),
                                                  child: Center(
                                                      child: IconWidget(
                                                    model: IconModel(
                                                      icon: Icons.language,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                  ))),
                                            ),
                                          )))))),
                    ]),
                  ),
                if (userStore.role == Role.onlineSchool &&
                    widget.homeStore!.ownArticlesStore.listData.isNotEmpty) ...[
                  30.h,
                  BodyGroup(title: t.profile.titleArticle, items: [
                    Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: SizedBox(
                            height: 250,
                            child: PaginatedLoadingWidget(
                              scrollDirection: Axis.horizontal,
                              store: widget.homeStore!.ownArticlesStore,
                              itemBuilder: (context, item) {
                                return ArticleBox(
                                  model: item,
                                );
                              },
                            ))),
                  ]),
                ],
                if (userStore.role == Role.user)
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: InkWell(
                      onTap: () {
                        context
                            .pushNamed(AppViews.registerFillBabyName, extra: {
                          'isNotRegister': true,
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image(
                          //   height: 17,
                          //   image: AssetImage(
                          //     Assets.icons.icAddChild.path,
                          //   ),
                          // ),
                          Icon(
                            AppIcons.plusSquareDashed,
                            color: AppColors.primaryColor,
                          ),
                          16.w,
                          Text(
                            t.profile.addChildButtonTitle,
                            style: widget.titlesColoredStyle?.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
