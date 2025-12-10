import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ispect/ispect.dart';
import 'package:provider/provider.dart';
import 'package:mama/src/feature/trackers/services/pdf_service.dart';
import 'package:mama/src/data.dart';

/// [MaterialContext] — главный материал-контекст приложения.
/// Отвечает за темы, локализацию и роутинг.
class MaterialContext extends StatefulWidget {
  const MaterialContext({super.key});

  @override
  State<MaterialContext> createState() => _MaterialContextState();
}

class _MaterialContextState extends State<MaterialContext> {
  final _controller = DraggablePanelController();
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    PdfService.rootMessengerKey = _messengerKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<Dependencies>(context).settingsStore;

    return Observer(
      builder: (_) {
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
              localizationsDelegates:
                  ISpectLocalizations.localizationDelegates([
                GlobalMaterialLocalizations.delegate,
              ]),
              supportedLocales: AppLocaleUtils.supportedLocales,
              locale: TranslationProvider.of(context).flutterLocale,
              builder: (context, child) {
                // ✅ корректная версия под ispect 4.4.7
                return ISpectBuilder(
                  options: ISpectOptions(
                    observer: null,
                    locale: TranslationProvider.of(context).flutterLocale,
                  ),
                  controller: _controller,
                  child: child ?? const SizedBox(),
                );
              },
            );
          },
        );
      },
    );
  }
}
