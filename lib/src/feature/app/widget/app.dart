import 'package:flutter/material.dart';
import 'package:mama/src/feature/trackers/state/medicine.dart';
import 'package:provider/provider.dart';
import 'package:mama/src/data.dart';

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
                restClient: context.read<Dependencies>().restClient,
                chatType: 'solo'),
          ),
          Provider(
            create: (context) => ChatsViewStore(
              restClient: context.read<Dependencies>().restClient,
            ),
          ),
          Provider(
              create: (context) => ChatSocket(
                    chatsViewStore: context.read<ChatsViewStore>(),
                    store: context.read<MessagesStore>(),
                    tokenStorage: context.read<Dependencies>().tokenStorage,
                  )),
          Provider(
              create: (context) => AuthStore(
                    restClient: context.read<Dependencies>().restClient,
                    tokenStorage: context.read<Dependencies>().tokenStorage,
                  )),
          Provider(
            create: (context) => AuthViewStore(),
            dispose: (context, value) => value.dispose(),
          ),
          Provider(
              create: (context) => VerifyStore(
                    restClient: context.read<Dependencies>().restClient,
                    tokenStorage: context.read<Dependencies>().tokenStorage,
                  )),
          Provider(
            create: (context) => UserStore(
                restClient: context.read<Dependencies>().restClient,
                verifyStore: context.read()),
          ),
          Provider(
            create: (context) => ChildStore(
              userStore: context.read<UserStore>(),
              restClient: context.read<Dependencies>().restClient,
            ),
          ),
          Provider(
            create: (context) => MedicineStore(
              restClient: context.read<Dependencies>().restClient,
            ),
          ),
          Provider(
            create: (context) => DoctorVisitStore(
              restClient: context.read<Dependencies>().restClient,
            ),
          ),
          Provider(
            create: (context) => VaccinesStore(
              restClient: context.read<Dependencies>().restClient,
            ),
          ),
          Provider(
            create: (context) => DoctorStore(
                restClient: context.read<Dependencies>().restClient),
          ),
          Provider(
              create: (context) => SchoolStore(
                  restClient: context.read<Dependencies>().restClient)),
          Provider(
            create: (context) => HomeViewStore(
                restClient: context.read<Dependencies>().restClient,
                userId: context.read<UserStore>().user.id),
          ),
          Provider(
            create: (context) => ScheduleViewStore(
              restClient: context.read<Dependencies>().restClient,
            ),
          ),
          Provider(
            dispose: (context, value) => value.dispose(),
            create: (context) => CalendarStore(store: context.read()),
          ),
          Provider(
            create: (context) => AudioPlayerStore(),
            dispose: (context, value) => value.dispose(),
          ),
          Provider(
              create: (context) => KnowledgeStore(
                    categoriesStore: CategoriesStore(
                        restClient: context.read<Dependencies>().restClient),
                    ageCategoriesStore: AgeCategoriesStore(
                        restClient: context.read<Dependencies>().restClient),
                    restClient: context.read<Dependencies>().restClient,
                  )),
        ],
        child: TranslationProvider(child: const MaterialContext()),
      );
}
