import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class MomsProfile extends StatefulWidget {
  final ProfileViewStore store;
  final MaskTextInputFormatter formatter;
  final AccountModel accountModel;

  final TextStyle? titlesStyle;
  final TextStyle? helpersStyle;
  final TextStyle? titlesColoredStyle;

  const MomsProfile({
    super.key,
    required this.store,
    this.titlesStyle,
    this.helpersStyle,
    this.titlesColoredStyle,
    required this.accountModel,
    required this.formatter,
  });

  @override
  State<MomsProfile> createState() => _MomsProfileState();
}

class _MomsProfileState extends State<MomsProfile> {
  @override
  void initState() {
    widget.store.init();
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

    return Column(
      children: [
        widget.accountModel.avatarUrl == null
            ? const DashedPhotoProfile()
            : const PhotoWidget(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.h,
              BodyGroup(
                formGroup: widget.store.formGroup,
                title: t.profile.accountTitle,
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
                  BodyItemWidget(
                    item: InputItem(
                      controlName: 'phone',
                      hintText: t.profile.hintChangePhone,
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
                        hintText: t.profile.hintChangeEmail,
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
                  BodyItemWidget(
                    item: InputItem(
                      errorBorder: InputBorder.none,
                      controlName: 'about',
                      maxLines: 1,
                      hintText: t.profile.hintChangeNote,
                      titleStyle: widget.titlesStyle!,
                      inputHint: t.profile.labelChangeNote,
                      inputHintStyle: textTheme.bodySmall,
                      onChanged: (value) {
                        userStore.account.setIsChanged(true);
                        // widget.store.updateData();
                      },
                    ),
                  ),
                ],
              ),
              32.h,
              CustomButton(
                isSmall: false,
                onTap: () {
                  context.pushNamed(AppViews.promoView);
                },
                title: t.profile.addGiftCodeButtonTitle,
              ),
              8.h,
              CustomButton(
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
              ),
              30.h,
              SubscribeBlockItem(
                child: Observer(builder: (_) {
                  return IgnorePointer(
                      ignoring: !userStore.isPro,
                      child: ChildItems(
                        childs: userStore.children.toList(),
                      ));
                }),
              ),
              if (userStore.role == Role.user)
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: InkWell(
                    onTap: () {
                      context.pushNamed(AppViews.registerFillBabyName, extra: {
                        'isNotRegister': true,
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          height: 17,
                          image: AssetImage(
                            Assets.icons.icAddChild.path,
                          ),
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
  }
}
