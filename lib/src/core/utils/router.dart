import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/feeding/views/bottle/add_bottle_screen.dart';
import 'package:mama/src/feature/home/view/day_work.dart';
import 'package:mama/src/feature/services/knowledge/views/saved_files_screen.dart';
import 'package:mama/src/feature/services/knowledge/views/service_info_screen.dart';

abstract class AppViews {
  static const String startScreen = 'startScreen';
  static const String auth = 'authScreen';
  static const String authVerify = 'authVerify';
  static const String registerVerify = 'registerVerify';
  static const String register = 'register';
  static const String congratsScreen = 'congrats';
  static const String registerFillName = 'registerFillName';
  static const String registerFillBabyName = 'registerFillBabyName';
  static const String registerFillAnotherBabyInfo =
      'registerFillAnotherBabyInfo';
  static const String registerInfoAboutChildbirth =
      'registerInfoAboutChildbirth';
  static const String citySearch = 'citySearch';
  static const String welcomeScreen = 'welcomeScreen';

  static const String homeScreen = 'homeScreen';

  static const trackersHealthView = 'trackersHealthView';
  static const addTemperature = 'addTemperature';

  static const trackersHealthAddMedicineView = 'trackersHealthAddMedicineView';

  // static const healthMedicine = '/';
  static const addMedicine = 'addMedicine';

  static const servicesUserView = 'servicesUserView';
  static const servicesSleepMusicView = 'servicesSleepMusicView';
  static const evolutionView = 'evolutionView';

  static const addWeightView = 'addWeightView';
  static const addGrowthView = 'addGrowthView';
  static const addHeadView = 'addHeadView';

  static const profile = 'profile';
  static const profileInfo = 'profileInfo';
  static const promoView = 'promoView';

  static const chatView = 'chatView';
  static const pinnedMessagesView = 'pinnedMessagesView';
  static const groupUsers = 'groupUsers';

  static const feeding = 'feeding';
  static const addManually = 'addManually';
  static const addPumping = 'addPumping';
  static const addLure = 'addLure';
  static const addBottle = 'addBottle';

  static const diapersView = 'diapersView';
  static const addDiaper = 'addDiaper';

  static const docs = 'docs';
  static const doc = 'doc';

  static const consultation = 'consultation';
  static const consultations = 'consultations';
  static const specializedConsultations = 'specializedConsultations';

  static const specialistConsultations = 'specialistConsultations';
  static const specialistSlots = 'specialistSlots';

  static const webView = 'webView';
  static const pdfView = 'pdfView';

  static const article = 'article';
  static const serviceKnowlegde = 'serviceKnowlegde';
  static const serviceKnowledgeInfo = 'serviceKnowledgeInfo';
  static const categories = 'categories';
  static const ages = 'ages';
  static const author = 'author';
  static const savedFiles = 'savedFiles';
}

final GlobalKey<NavigatorState> navKey = GlobalKey();

final GoRouter router = GoRouter(
  navigatorKey: navKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: _Paths.startScreen,
      name: AppViews.startScreen,
      builder: (context, state) {
        return const StartScreen();
      },
    ),
    GoRoute(
      path: _Paths.register,
      name: AppViews.register,
      builder: (context, state) => const AuthView(),
      routes: [
        GoRoute(
          path: _Paths.auth,
          name: AppViews.auth,
          builder: (context, state) => const AuthView(isLogin: true),
        ),
        GoRoute(
          path: _Paths.registerVerify,
          name: AppViews.registerVerify,
          routes: [
            GoRoute(
                path: _Paths.authVerify,
                name: AppViews.authVerify,
                builder: (context, state) {
                  return const PhoneVerify(
                    isLogin: true,
                  );
                }),
          ],
          builder: (context, state) {
            return const PhoneVerify();
          },
        ),
        GoRoute(
            path: _Paths.welcomeScreen,
            name: AppViews.welcomeScreen,
            routes: [
              GoRoute(
                path: _Paths.registerFillName,
                name: AppViews.registerFillName,
                builder: (context, state) {
                  return const RegisterFillName();
                },
              ),
            ],
            builder: (context, state) => const WelcomeScreen()),
        GoRoute(
          path: _Paths.congratsScreen,
          name: AppViews.congratsScreen,
          builder: (context, state) => const CongratsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: _Paths.homeScreen,
      name: AppViews.homeScreen,
      builder: (context, state) => const HomeView(),
      routes: [
        GoRoute(
            path: _Paths.article,
            name: AppViews.article,
            builder: (context, state) {
              final Map? extra = state.extra as Map?;
              final String? id = extra?['id'] as String?;

              return ArticleView(
                id: id,
              );
            }),
        GoRoute(
          name: AppViews.servicesUserView,
          path: _Paths.servicesUserPath,
          builder: (context, state) => const ServicesView(
            appBar: CustomAppBar(),
          ),
          routes: [
            GoRoute(
                path: _Paths.consultations,
                name: AppViews.consultations,
                routes: [
                  GoRoute(
                    path: _Paths.consultation,
                    name: AppViews.consultation,
                    builder: (context, state) {
                      final Map? extra = state.extra as Map?;
                      final DoctorModel? doctor =
                          extra?['doctor'] as DoctorModel?;
                      final Consultation? consultation =
                          extra?['consultation'] as Consultation?;

                      final int? selectedTab = extra?['selectedTab'] as int?;

                      return ConsultationView(
                        consultation: consultation,
                        doctor: doctor,
                        selectedTab: selectedTab,
                      );
                    },
                  )
                ],
                builder: (context, state) {
                  final Map? extra = state.extra as Map?;
                  final int? selectedTab = extra?['selectedTab'] as int?;

                  return ConsultationsView(
                    initialIndex: selectedTab ?? 0,
                  );
                }),
            GoRoute(
              path: _Paths.specializedConsultations,
              name: AppViews.specializedConsultations,
              builder: (context, state) {
                return const SpecialistConsultingScreen();
              },
            ),
            GoRoute(
              name: AppViews.servicesSleepMusicView,
              path: _Paths.servicesSleepMusicPath,
              builder: (context, state) {
                final Map? extra = state.extra as Map?;
                final int? selectedTab = extra?['selectedTab'] as int?;

                return SleepMusicView(
                  index: selectedTab ?? 0,
                );
              },
            ),
            GoRoute(
              name: AppViews.serviceKnowlegde,
              path: _Paths.serviceKnowledge,
              builder: (context, state) => const KnowledgeView(),
              routes: [
                GoRoute(
                  name: AppViews.categories,
                  path: _Paths.categories,
                  builder: (context, state) => const CategoriesView(),
                ),
                GoRoute(
                  name: AppViews.ages,
                  path: _Paths.ages,
                  builder: (context, state) => const AgeCategoryView(),
                ),
                // GoRoute(
                //   name: AppViews.author,
                //   path: _Paths.author,
                //   builder: (context, state) => const AuthorsScreen(),
                // ),
                GoRoute(
                  name: AppViews.savedFiles,
                  path: _Paths.savedFiles,
                  builder: (context, state) => const SavedFilesScreen(),
                ),
                GoRoute(
                  name: AppViews.serviceKnowledgeInfo,
                  path: _Paths.serviceKnowledgeInfo,
                  builder: (context, state) => const ServiceInfoScreen(),
                ),
              ],
            ),
            GoRoute(
                path: _Paths.specialistConsultations,
                name: AppViews.specialistConsultations,
                routes: [
                  GoRoute(
                    path: _Paths.specialistSlots,
                    name: AppViews.specialistSlots,
                    builder: (context, state) {
                      final Map? extra = state.extra as Map?;
                      final List<CalendarEventData<Object?>> event =
                          extra?['event'] as List<CalendarEventData<Object?>>;
                      return SpecialistDayView(
                        event: event,
                      );
                    },
                  )
                ],
                builder: (context, state) =>
                    const SpecialistConsultationsView()),
          ],
        ),
        GoRoute(
            path: _Paths.evolutionView,
            name: AppViews.evolutionView,
            builder: (context, state) => const EvolutionView(),
            routes: [
              GoRoute(
                name: AppViews.addWeightView,
                path: _Paths.addWeightView,
                builder: (context, state) => const AddWeight(),
              )
            ]),
        GoRoute(
          path: _Paths.feeding,
          name: AppViews.feeding,
          builder: (context, state) => const FeedingScreen(),
          routes: [
            GoRoute(
              name: AppViews.addManually,
              path: _Paths.addManually,
              builder: (context, state) => const AddManuallyScreen(),
            ),
            GoRoute(
              name: AppViews.addPumping,
              path: _Paths.addPumping,
              builder: (context, state) => const AddPumpingScreen(),
            ),
            GoRoute(
              name: AppViews.addBottle,
              path: _Paths.addBottle,
              builder: (context, state) => const AddBottleScreen(),
            ),
            GoRoute(
              name: AppViews.addLure,
              path: _Paths.addLure,
              builder: (context, state) => const AddLureScreen(),
            ),
          ],
        ),
        GoRoute(
          name: AppViews.trackersHealthView,
          path: _Paths.trackersHealthPath,
          builder: (context, state) => const TrackersHealthView(),
          routes: [
            GoRoute(
              name: AppViews.trackersHealthAddMedicineView,
              path: _Paths.trackersHealthAddTemperaturePath,
              builder: (context, state) => const TrackersHealthAddTemperature(),
            )
          ],
        ),
        GoRoute(
            name: AppViews.diapersView,
            path: _Paths.diapers,
            builder: (context, state) => const DiapersView(),
            routes: [
              GoRoute(
                  path: _Paths.addDiapers,
                  name: AppViews.addDiaper,
                  builder: (context, state) => const AddDiaper())
            ]),
        GoRoute(
            path: _Paths.chat,
            name: AppViews.chatView,
            builder: (context, state) {
              final Map? extra = state.extra as Map?;
              final item = extra?['item'];

              return ChatView(
                item: item,
              );
            },
            routes: [
              GoRoute(
                path: _Paths.groupUsers,
                name: AppViews.groupUsers,
                builder: (context, state) {
                  final Map? extra = state.extra as Map?;
                  final GroupUsersStore? store =
                      extra?['store'] as GroupUsersStore?;
                  final GroupChatInfo? groupInfo = extra?['groupInfo'];
                  return GroupUsersView(
                    store: store,
                    groupInfo: groupInfo,
                  );
                },
              ),
              GoRoute(
                path: _Paths.pinnedMessages,
                name: AppViews.pinnedMessagesView,
                builder: (context, state) {
                  final Map? extra = state.extra as Map?;
                  final MessagesStore? store =
                      extra?['store'] as MessagesStore?;
                  final ScrollController? scrollController =
                      extra?['scrollController'] as ScrollController?;

                  return PinnedMessagesView(
                    store: store,
                    scrollController: scrollController,
                  );
                },
              )
            ]),
        GoRoute(
          path: _Paths.profile,
          name: AppViews.profile,
          builder: (context, state) => const ProfileScreen(),
          routes: [
            GoRoute(
              path: _Paths.promoView,
              name: AppViews.promoView,
              builder: (context, state) => const PromoScreen(),
            )
          ],
        ),
        GoRoute(
          path: _Paths.profileInfo,
          name: AppViews.profileInfo,
          builder: (context, state) {
            final Map? extra = state.extra as Map?;
            final BaseModel? model = extra?['model'] as BaseModel?;

            return ProfileInfoView(
              model: model!,
            );
          },
        )
      ],
    ),
    GoRoute(
      path: _Paths.docsView,
      name: AppViews.docs,
      builder: (context, state) => const DocsView(),
    ),
    GoRoute(
        path: _Paths.webView,
        name: AppViews.webView,
        builder: (context, state) {
          final Map? extra = state.extra as Map?;
          final String? url = extra?['url'] as String?;

          return WebView(
            url: url ?? '',
          );
        }),
    GoRoute(
        path: _Paths.pdfView,
        name: AppViews.pdfView,
        builder: (context, state) {
          final Map? extra = state.extra as Map?;
          final String? path = extra?['path'] as String?;

          return PdfView(
            path: path ?? '',
          );
        }),
    GoRoute(
      path: _Paths.registerFillBabyName,
      name: AppViews.registerFillBabyName,
      builder: (context, state) {
        final Map? extra = state.extra as Map?;
        final bool? isNotRegister = extra?['isNotRegister'] as bool?;

        return RegisterBabyNameScreen(
          isNotRegister: isNotRegister ?? false,
        );
      },
      routes: [
        GoRoute(
          path: _Paths.registerFillAnotherBabyInfo,
          name: AppViews.registerFillAnotherBabyInfo,
          builder: (context, state) {
            final Map? extra = state.extra as Map?;
            final bool? isNotRegister = extra?['isNotRegister'] as bool?;

            return RegisterFillAnotherBabyInfoScreen(
              isNotRegister: isNotRegister ?? false,
            );
          },
          routes: [
            GoRoute(
              path: _Paths.registerInfoAboutChildbirth,
              name: AppViews.registerInfoAboutChildbirth,
              builder: (context, state) {
                final Map? extra = state.extra as Map?;
                final bool? isNotRegister = extra?['isNotRegister'] as bool?;

                return RegisterInfoAboutChildbirth(
                  isNotRegister: isNotRegister ?? false,
                );
              },
              routes: [
                GoRoute(
                  path: _Paths.citySearch,
                  name: AppViews.citySearch,
                  builder: (context, state) {
                    return const CitySearchView();
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

abstract class _Paths {
  static const String startScreen = '/';
  static const String auth = AppViews.auth;
  static const String authVerify = AppViews.authVerify;
  static const String registerVerify = AppViews.registerVerify;
  static const String register = '/${AppViews.register}';
  static const String congratsScreen = AppViews.congratsScreen;
  static const String registerFillName = AppViews.registerFillName;
  static const String registerFillBabyName =
      '/${AppViews.registerFillBabyName}';
  static const String registerFillAnotherBabyInfo =
      AppViews.registerFillAnotherBabyInfo;
  static const String registerInfoAboutChildbirth =
      AppViews.registerInfoAboutChildbirth;
  static const String citySearch = AppViews.citySearch;
  static const String welcomeScreen = AppViews.welcomeScreen;

  static const String homeScreen = '/${AppViews.homeScreen}';

  static const trackersHealthPath = AppViews.trackersHealthView;
  static const trackersHealthAddTemperaturePath = AppViews.addTemperature;

  // static const healthMedicine = AppViews.healthMedicine;
  // static const addMedicine = AppViews.addMedicine;

  static const servicesUserPath = AppViews.servicesUserView;
  static const servicesSleepMusicPath = AppViews.servicesSleepMusicView;
  static const evolutionView = AppViews.evolutionView;

  static const addWeightView = AppViews.addWeightView;
  // static const addGrowthView = AppViews.addGrowthView;
  // static const addHeadView = AppViews.addHeadView;

  static const profile = AppViews.profile;
  static const profileInfo = AppViews.profileInfo;
  static const promoView = AppViews.promoView;

  static const chat = AppViews.chatView;
  static const pinnedMessages = AppViews.pinnedMessagesView;
  static const groupUsers = AppViews.groupUsers;

  static const feeding = AppViews.feeding;
  static const diapers = AppViews.diapersView;
  static const addDiapers = AppViews.addDiaper;

  static const addManually = AppViews.addManually;
  static const addPumping = AppViews.addPumping;
  static const addLure = AppViews.addLure;
  static const addBottle = AppViews.addBottle;

  static const serviceKnowledge = AppViews.serviceKnowlegde;

  static const consultation = AppViews.consultation;
  static const consultations = AppViews.consultations;
  static const specializedConsultations = AppViews.specializedConsultations;

  static const specialistConsultations = AppViews.specialistConsultations;

  static const specialistSlots = AppViews.specialistSlots;

  static const webView = '/${AppViews.webView}';
  static const pdfView = '/${AppViews.pdfView}';
  static const docsView = '/${AppViews.docs}';

  static const article = AppViews.article;
  static const serviceKnowledgeInfo = AppViews.serviceKnowledgeInfo;
  static const categories = AppViews.categories;
  static const ages = AppViews.ages;
  static const author = AppViews.author;
  static const savedFiles = AppViews.savedFiles;
}
