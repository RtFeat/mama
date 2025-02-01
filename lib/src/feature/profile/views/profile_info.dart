import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/core/widgets/body/decoration.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class ProfileInfoView extends StatelessWidget {
  final BaseModel model;
  const ProfileInfoView({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    final SchoolModel? schoolModel =
        model is SchoolModel ? model as SchoolModel : null;
    final DoctorModel? doctorModel =
        model is DoctorModel ? model as DoctorModel : null;
    final AccountModel? userModel =
        model is AccountModel ? model as AccountModel : null;

    final Role role = doctorModel != null
        ? Role.doctor
        : schoolModel != null
            ? Role.onlineSchool
            : Role.user;

    logger.info('Role: $role');

    logger.info(switch (role) {
      Role.onlineSchool => 'school: ${schoolModel?.toJson()}',
      Role.doctor => 'doctor: ${doctorModel?.toJson()}',
      _ => 'User: ${userModel?.toJson()}',
    });

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
            child: Stack(children: [
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  ProfilePhoto(
                    isShowIcon: role == Role.user,
                    onIconTap: () {},
                    icon: const Material(
                      shape: CircleBorder(),
                      color: AppColors.primaryColor,
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          AppIcons.bubbleLeftFill,
                          size: 32,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                    photoUrl: switch (role) {
                      Role.doctor => doctorModel?.account?.avatarUrl,
                      Role.onlineSchool => schoolModel?.account?.avatarUrl,
                      _ => userModel?.avatarUrl,
                    },
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Column(
                        children: [
                          if (role == Role.onlineSchool) ...[
                            Text(
                              t.profile.onlineSchool,
                              style: textTheme.headlineSmall?.copyWith(
                                fontSize: 17,
                                color: AppColors.greyBrighterColor,
                              ),
                            ),
                            4.h,
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                switch (role) {
                                  Role.doctor =>
                                    doctorModel?.account?.name ?? '',
                                  Role.onlineSchool =>
                                    schoolModel?.account?.name ?? '',
                                  _ => userModel?.name ?? '',
                                },
                                textAlign: TextAlign.center,
                                style: textTheme.headlineSmall?.copyWith(
                                  fontSize: 24,
                                ),
                              ),
                              if (doctorModel?.profession != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 18),
                                  child: ConsultationBadge(
                                    title: doctorModel?.profession ?? '',
                                  ),
                                )
                            ],
                          ),
                          if (role == Role.doctor)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 16),
                              child: CustomButton(
                                title: t.profile.consultationVariants,
                                isSmall: false,
                                // icon: IconModel(
                                //   iconPath: Assets.icons.videoIcon,
                                // ),
                                icon: AppIcons.videoBubbleLeftFill,
                                onTap: () {},
                              ),
                            ),
                        ],
                      )),
                  BodyGroup(
                      title: t.profile.titleInfo,
                      isDecorated: true,
                      items: [
                        BodyItemWidget(
                          item: CustomBodyItem(
                              subTitleWidth: double.infinity,
                              title: switch (role) {
                                Role.onlineSchool =>
                                  schoolModel?.account?.info ?? '',
                                _ => userModel?.info ?? '',
                              },
                              subTitle: switch (role) {
                                Role.onlineSchool => t.profile.aboutSchool,
                                _ => t.profile.aboutMe2,
                              }),
                        )
                      ]),
                  _Body(
                    store: context.watch(),
                    role: role,
                    userId: switch (role) {
                      Role.doctor => doctorModel?.id ?? '',
                      Role.onlineSchool => schoolModel?.id ?? '',
                      _ => userModel?.id ?? '',
                    },
                    schoolId: schoolModel?.id ?? '',
                  )
                ],
              ),
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
                  labelStyle: textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.w400),
                  onTapButton: () async {
                    context.pop();
                  },
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(20),
                  ),
                ),
              ),
            ])));
  }
}

class _Body extends StatefulWidget {
  final HomeViewStore store;
  final Role role;
  final String userId;
  final String schoolId;
  const _Body({
    required this.store,
    required this.role,
    required this.userId,
    required this.schoolId,
  });

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  @override
  void initState() {
    switch (widget.role) {
      case Role.doctor:
        widget.store.loadOwnArticles(widget.userId);
        break;
      case Role.onlineSchool:
        widget.store.loadOwnArticles(widget.userId);
        widget.store.loadSchoolCourses(widget.schoolId);
        break;
      case _:
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    switch (widget.role) {
      case Role.onlineSchool:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Observer(
              builder: (context) => BodyGroup(
                      title: t.profile.titleCourses,
                      isDecorated: false,
                      items: [
                        ...widget.store.coursesStore.listData.map((item) =>
                            SizedBox(
                                height: 120,
                                child: BodyItemDecoration(
                                    borderRadius: 32.r,
                                    padding: const EdgeInsets.only(left: 10),
                                    child: BodyItemWidget(
                                        item: CustomBodyItem(
                                            bodyAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            title: item.title ?? '',
                                            titleStyle: textTheme.headlineSmall
                                                ?.copyWith(
                                              fontSize: 20,
                                            ),
                                            subTitleLines: 2,
                                            hintStyle: textTheme.titleSmall,
                                            subTitle:
                                                item.shortDescription ?? '',
                                            subTitleWidth: double.infinity,
                                            body: GestureDetector(
                                              onTap: () {
                                                context.pushNamed(
                                                    AppViews.webView,
                                                    extra: {
                                                      'url': item.link,
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
                        if (widget
                            .store.ownArticlesStore.listData.isNotEmpty) ...[
                          30.h,
                          BodyGroup(title: t.profile.titleArticle, items: [
                            Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: SizedBox(
                                    height: 250,
                                    child: PaginatedLoadingWidget(
                                      scrollDirection: Axis.horizontal,
                                      store: widget.store.ownArticlesStore,
                                      itemBuilder: (context, item, _) {
                                        return ArticleBox(
                                          model: item,
                                        );
                                      },
                                    ))),
                          ])
                        ]
                      ])),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
