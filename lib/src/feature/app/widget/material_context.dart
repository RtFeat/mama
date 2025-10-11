import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ispect/ispect.dart';
import 'package:provider/provider.dart';
import 'package:mama/src/feature/trackers/services/pdf_service.dart';
import 'package:mama/src/data.dart';

/// [MaterialContext] is an entry point to the material context.
///
/// This widget sets locales, themes and routing.
class MaterialContext extends StatefulWidget {
  const MaterialContext({super.key});

  // This global key is needed for [MaterialApp]
  // to work properly when Widgets Inspector is enabled.
  // static final _globalKey = GlobalKey();

  @override
  State<MaterialContext> createState() => _MaterialContextState();
}

class _MaterialContextState extends State<MaterialContext> {
  final _controller = DraggablePanelController();
  final _observer = ISpectNavigatorObserver(
    isLogModals: false,
    isLogPages: false,
  );
  final GlobalKey<ScaffoldMessengerState> _messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    PdfService.rootMessengerKey = _messengerKey;
    // router.routerDelegate.addListener(() {
    //   final String location =
    //       router.routerDelegate.currentConfiguration.last.matchedLocation;
    //   iSpectify.route(location);
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<Dependencies>(context).settingsStore;

    return Observer(builder: (_) {
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
        scaffoldMessengerKey: _messengerKey,
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
      );
        },
      );
    });
  }
}
