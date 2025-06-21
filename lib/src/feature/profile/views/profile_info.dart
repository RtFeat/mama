import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/core/widgets/body/decoration.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class ProfileInfoView extends StatelessWidget {
  final AccountModel model;
  final String? schoolId;
  final bool? hasChat;
  const ProfileInfoView({
    super.key,
    required this.model,
    this.schoolId,
    this.hasChat,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    logger.info(switch (model.role) {
      Role.onlineSchool => 'school: ${model.toJson()}',
      Role.doctor => 'doctor: ${model.toJson()}',
      _ => 'User: ${model.toJson()}',
    });

    logger.info('schoolId: ${schoolId}');

    return Provider(
      create: (context) => ProfileInfoViewStore(
          socket: context.read(),
          chatsViewStore: context.read(),
          messagesStore: context.read(),
          apiClient: context.read<Dependencies>().apiClient),
      builder: (context, child) {
        final ProfileInfoViewStore store =
            context.watch<ProfileInfoViewStore>();

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
                        isShowIcon:
                            model.role == Role.user || model.role == Role.admin,
                        onIconTap: () {
                          store.createChat(model.id!);
                        },
                        onDeleteTap: hasChat ?? false
                            ? () {
                                store.deleteChat();
                              }
                            : null,
                        icon: Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              AppIcons.bubbleLeftFill,
                              size: 32,
                              color: AppColors.whiteColor,
                            )),
                        photoUrl: switch (model.role) {
                          Role.doctor => model.avatarUrl,
                          Role.onlineSchool => model.avatarUrl,
                          _ => model.avatarUrl,
                        },
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 22),
                          child: Column(
                            children: [
                              if (model.role == Role.onlineSchool) ...[
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
                                    switch (model.role) {
                                      Role.doctor => model.name,
                                      Role.onlineSchool => model.name,
                                      _ => model.name,
                                    },
                                    textAlign: TextAlign.center,
                                    style: textTheme.headlineSmall?.copyWith(
                                      fontSize: 24,
                                    ),
                                  ),
                                  if (model.profession != null &&
                                      model.profession!.isNotEmpty) ...[
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 18),
                                      child: ConsultationBadge(
                                        title: model.profession ?? '',
                                      ),
                                    )
                                  ]
                                ],
                              ),
                              if (model.role == Role.doctor)
                                _GetConsultation(
                                  store: context.watch(),
                                  doctorId: model.id ?? '',
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
                                  title: switch (model.role) {
                                    Role.onlineSchool => model.info ?? '',
                                    _ => model.info ?? '',
                                  },
                                  subTitle: switch (model.role) {
                                    Role.onlineSchool => t.profile.aboutSchool,
                                    _ => t.profile.aboutMe2,
                                  }),
                            )
                          ]),
                      _Body(
                        store: context.watch(),
                        role: model.role ?? Role.user,
                        userId: switch (model.role) {
                          Role.doctor => model.id ?? '',
                          Role.onlineSchool => model.id ?? '',
                          _ => model.id ?? '',
                        },
                        schoolId: schoolId ?? '',
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
      },
    );
  }
}

class _GetConsultation extends StatefulWidget {
  final String doctorId;
  final HomeViewStore store;
  const _GetConsultation({
    required this.store,
    required this.doctorId,
  });

  @override
  State<_GetConsultation> createState() => _GetConsultationState();
}

class _GetConsultationState extends State<_GetConsultation> {
  @override
  void initState() {
    widget.store.loadDoctorData(widget.doctorId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: CustomButton(
          title: t.profile.consultationVariants,
          isSmall: false,
          // icon: IconModel(
          //   iconPath: Assets.icons.videoIcon,
          // ),
          icon: AppIcons.videoBubbleLeftFill,
          onTap: () {
            context.pushNamed(AppViews.consultation, extra: {
              'doctor': widget.store.doctorData,
            });
          },
        ),
      );
    });
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
        widget.store.loadAllArticles(schoolId: widget.userId);
        break;
      case Role.onlineSchool:
        widget.store.ownArticlesStore.resetPagination();
        widget.store.coursesStore.resetPagination();
        widget.store.loadAllArticles(schoolId: widget.schoolId);
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
              builder: (context) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BodyGroup(
                            title: t.profile.titleCourses,
                            isDecorated: false,
                            items: [
                              CustomScrollView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                slivers: [
                                  PaginatedLoadingWidget(
                                    emptyData: SliverToBoxAdapter(
                                        child: SizedBox.shrink()),
                                    isFewLists: true,
                                    store: widget.store.coursesStore,
                                    itemBuilder: (context, item, index) {
                                      return SizedBox(
                                          height: 120,
                                          child: BodyItemDecoration(
                                              borderRadius: 32.r,
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: BodyItemWidget(
                                                  item: CustomBodyItem(
                                                      bodyAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      title: item.title ?? '',
                                                      titleStyle: textTheme
                                                          .headlineSmall
                                                          ?.copyWith(
                                                        fontSize: 20,
                                                      ),
                                                      subTitleLines: 2,
                                                      hintStyle:
                                                          textTheme.titleSmall,
                                                      subTitle:
                                                          item.shortDescription ??
                                                              '',
                                                      subTitleWidth:
                                                          double.infinity,
                                                      body: GestureDetector(
                                                        onTap: () {
                                                          context.pushNamed(
                                                              AppViews.webView,
                                                              extra: {
                                                                'url':
                                                                    item.link,
                                                              });
                                                        },
                                                        child: SizedBox(
                                                          width: 70,
                                                          child: DecoratedBox(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors
                                                                    .lightBlueBackgroundStatus,
                                                                borderRadius:
                                                                    32.r,
                                                              ),
                                                              child: Center(
                                                                  child:
                                                                      IconWidget(
                                                                model:
                                                                    IconModel(
                                                                  icon: Icons
                                                                      .language,
                                                                  color: AppColors
                                                                      .primaryColor,
                                                                ),
                                                              ))),
                                                        ),
                                                      )))));
                                    },
                                  ),
                                ],
                              ),
                              // if (widget
                              //     .store.ownArticlesStore.listData.isNotEmpty)
                            ]),
                        30.h,
                        BodyGroup(title: t.profile.titleArticle, items: [
                          SizedBox(
                            height: 250,
                            child: PaginatedLoadingWidget(
                              padding: EdgeInsets.only(left: 16),
                              emptyData:
                                  SliverToBoxAdapter(child: SizedBox.shrink()),
                              scrollDirection: Axis.horizontal,
                              store: widget.store.allArticlesStore,
                              itemBuilder: (context, item, _) {
                                return ArticleBox(
                                  model: item,
                                );
                              },
                            ),
                          )
                        ])
                      ])),
        );

      case Role.doctor:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Observer(
              builder: (context) =>
                  BodyGroup(title: t.profile.titleArticle, items: [
                    SizedBox(
                      height: 250,
                      child: PaginatedLoadingWidget(
                        padding: EdgeInsets.only(left: 16),
                        emptyData: SliverToBoxAdapter(child: SizedBox.shrink()),
                        scrollDirection: Axis.horizontal,
                        store: widget.store.allArticlesStore,
                        itemBuilder: (context, item, _) {
                          return ArticleBox(
                            model: item,
                          );
                        },
                      ),
                    )
                  ])),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
