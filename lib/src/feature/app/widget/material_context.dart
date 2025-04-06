import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ispect/ispect.dart';
import 'package:provider/provider.dart';
import 'package:mama/src/data.dart';
import 'package:mama/main.dart';

/// [MaterialContext] is an entry point to the material context.
///
/// This widget sets locales, themes and routing.
class MaterialContext extends StatefulWidget {
  const MaterialContext({super.key});

  // This global key is needed for [MaterialApp]
  // to work properly when Widgets Inspector is enabled.
  static final _globalKey = GlobalKey();

  @override
  State<MaterialContext> createState() => _MaterialContextState();
}

class _MaterialContextState extends State<MaterialContext> {
  final _controller = DraggablePanelController();
  final _observer = ISpectNavigatorObserver(
    isLogModals: false,
  );

  @override
  void initState() {
    router.routerDelegate.addListener(() {
      final String location =
          router.routerDelegate.currentConfiguration.last.matchedLocation;
      iSpectify.route(location);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<Dependencies>(context).settingsStore;

    return Observer(builder: (_) {
      return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          }
        },
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          theme: settings.lightTheme,
          darkTheme: settings.darkTheme,
          themeMode: ThemeMode.light,
          localizationsDelegates: ISpectLocalizations.localizationDelegates([
            GlobalMaterialLocalizations.delegate,
          ]),
          supportedLocales: AppLocaleUtils.supportedLocales,
          locale: TranslationProvider.of(context).flutterLocale,
          // builder: (context, child) => MediaQuery.withClampedTextScaling(
          //   key: _globalKey,
          //   minScaleFactor: 1.0,
          //   maxScaleFactor: 2.0,
          //   child: child!,
          // ),
          builder: (context, child) {
            child = ISpectBuilder(
              options: ISpectOptions(
                locale: TranslationProvider.of(context).flutterLocale,
                panelButtons: [
                  (
                    icon: Icons.copy_rounded,
                    label: 'Token',
                    onTap: (context) {
                      _controller.toggle(context);
                      debugPrint('Token copied');
                    },
                  ),
                ],
                panelItems: [
                  (
                    icon: Icons.home,
                    enableBadge: false,
                    onTap: (context) {
                      debugPrint('Home');
                    },
                  ),
                ],
                actionItems: [
                  ISpectifyActionItem(
                    title: 'Test',
                    icon: Icons.account_tree_rounded,
                    onTap: (context) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Scaffold(
                            body: Center(
                              child: Text('Test'),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              theme: ISpectTheme(
                pageTitle: 'Custom Name',
                logDescriptions: [
                  LogDescription(
                    key: 'bloc-event',
                    isDisabled: true,
                  ),
                  LogDescription(
                    key: 'bloc-transition',
                    isDisabled: true,
                  ),
                  LogDescription(
                    key: 'bloc-close',
                    isDisabled: true,
                  ),
                  LogDescription(
                    key: 'bloc-create',
                    isDisabled: true,
                  ),
                  LogDescription(
                    key: 'bloc-state',
                    isDisabled: true,
                  ),
                  LogDescription(
                    key: 'riverpod-add',
                    isDisabled: true,
                  ),
                  LogDescription(
                    key: 'riverpod-update',
                    isDisabled: true,
                  ),
                  LogDescription(
                    key: 'riverpod-dispose',
                    isDisabled: true,
                  ),
                  LogDescription(
                    key: 'riverpod-fail',
                    isDisabled: true,
                  ),
                ],
              ),
              observer: _observer,
              controller: _controller,
              initialPosition: (x: 0, y: 200),
              onPositionChanged: (x, y) {
                debugPrint('x: $x, y: $y');
              },
              child: child ?? const SizedBox(),
            );
            return child;
          },
        ),
      );
    });
  }
}
