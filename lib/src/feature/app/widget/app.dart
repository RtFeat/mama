import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart' as skit;

/// [App] is an entry point to the application.
///
/// Scopes that don't depend on widgets returned by [MaterialApp]
/// ([Directionality], [MediaQuery], [Localizations]) should be placed here.
class App extends StatelessWidget {
  const App({required this.result, super.key});

  /// The initialization result from the [InitializationProcessor]
  /// which contains initialized dependencies.
  final InitializationResult result;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider(
            create: (context) => result.dependencies,
          ),
          Provider(
            create: (context) => MessagesStore(
                faker: context.read<Dependencies>().faker,
                apiClient: context.read<Dependencies>().apiClient,
                chatType: 'solo'),
          ),
          Provider(
            create: (context) => ChatsViewStore(
              faker: context.read<Dependencies>().faker,
              apiClient: context.read<Dependencies>().apiClient,
            ),
          ),
          Provider(
              create: (context) => ChatSocket(
                    chatsViewStore: context.read<ChatsViewStore>(),
                    store: context.read<MessagesStore>(),
                    tokenStorage: context.read<Dependencies>().tokenStorage,
                  )),
          Provider(
              create: (context) =>
                  FirebaseMessageStore(store: context.read<MessagesStore>())),
          Provider(
              create: (context) => AuthStore(
                    apiClient: context.read<Dependencies>().apiClient,
                    tokenStorage: context.read<Dependencies>().tokenStorage,
                  )),
          Provider(
            create: (context) => AuthViewStore(),
            dispose: (context, value) => value.dispose(),
          ),
          Provider(
              create: (context) => VerifyStore(
                    apiClient: context.read<Dependencies>().apiClient,
                    tokenStorage: context.read<Dependencies>().tokenStorage,
                  )),
          Provider(
            create: (context) => UserStore(
                faker: context.read<Dependencies>().faker,
                apiClient: context.read<Dependencies>().apiClient,
                verifyStore: context.read()),
          ),
          Provider(
            create: (context) => ChildStore(
              userStore: context.read<UserStore>(),
              apiClient: context.read<Dependencies>().apiClient,
            ),
          ),
          Provider(
            create: (context) => MedicineStore(
              restClient: context.read<Dependencies>().apiClient,
            ),
          ),
          Provider(
            create: (context) => DoctorVisitStore(
              restClient: context.read<Dependencies>().apiClient,
            ),
          ),
          Provider(
            create: (context) => VaccinesStore(
              restClient: context.read<Dependencies>().apiClient,
            ),
          ),
          Provider(
            create: (context) => MedicineStore(
              restClient: context.read<Dependencies>().apiClient,
            ),
          ),
          Provider(
            create: (context) => DoctorVisitStore(
              restClient: context.read<Dependencies>().apiClient,
            ),
          ),
          Provider(
            create: (context) => VaccinesStore(
              restClient: context.read<Dependencies>().apiClient,
            ),
          ),
          Provider(
            create: (context) => DoctorStore(
                faker: context.read<Dependencies>().faker,
                apiClient: context.read<Dependencies>().apiClient),
          ),
          Provider(
              create: (context) => SchoolStore(
                  faker: context.read<Dependencies>().faker,
                  apiClient: context.read<Dependencies>().apiClient)),
          Provider(
            create: (context) => HomeViewStore(
                faker: context.read<Dependencies>().faker,
                apiClient: context.read<Dependencies>().apiClient,
                userId: context.read<UserStore>().user.id),
          ),
          Provider(
            create: (context) => ScheduleViewStore(
              apiClient: context.read<Dependencies>().apiClient,
            ),
          ),
          Provider(
            dispose: (context, value) => value.dispose(),
            create: (context) => CalendarStore(store: context.read()),
          ),
          Provider(
            create: (context) => skit.AudioPlayerStore(),
            dispose: (context, value) => value.dispose(),
          ),
          Provider(
            create: (_) => FavoriteArticlesStore(
              faker: context.read<Dependencies>().faker,
              apiClient: context.read<Dependencies>().apiClient,
            ),
          ),
          Provider(
            create: (context) => KnowledgeStore(
              faker: context.read<Dependencies>().faker,
              authorsStore: AuthorsStore(
                  faker: context.read<Dependencies>().faker,
                  apiClient: context.read<Dependencies>().apiClient),
              categoriesStore: CategoriesStore(
                  faker: context.read<Dependencies>().faker,
                  apiClient: context.read<Dependencies>().apiClient),
              ageCategoriesStore: AgeCategoriesStore(
                  faker: context.read<Dependencies>().faker,
                  apiClient: context.read<Dependencies>().apiClient),
              apiClient: context.read<Dependencies>().apiClient,
            ),
          ),
        ],
        child: TranslationProvider(child: const MaterialContext()),
      );
}
