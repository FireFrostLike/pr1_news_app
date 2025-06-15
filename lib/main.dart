import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:pr1_news_app/data/local_storage.dart';
import 'package:pr1_news_app/screens/article_screen.dart';
import 'package:pr1_news_app/screens/favorites_screen.dart';
import 'package:pr1_news_app/screens/news_screen.dart';
import 'package:pr1_news_app/screens/settigns_screen.dart';
import 'package:pr1_news_app/theme/app_theme.dart';

import 'generated/l10n.dart';

void main() async {
  await settingsInit();

  GetIt.I.registerSingleton<LocalStorage>(LocalStorage(true));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isLightTheme;
  late Locale locale;

  @override
  void initState() {
    isLightTheme = GetIt.I<LocalStorage>().getBoolTheme();
    locale = Locale(GetIt.I<LocalStorage>().getLocale());

    GetIt.I<LocalStorage>().themeListenable().addListener(() {
      setState(() {
        isLightTheme = GetIt.I<LocalStorage>().getBoolTheme();
      });
    });

    GetIt.I<LocalStorage>().languageListenable().addListener(() {
      setState(() {

      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: Locale(GetIt.I<LocalStorage>().getLocale()),
      theme: AppTheme.theme(true),
      darkTheme: AppTheme.theme(false),
      themeMode: GetIt.I<LocalStorage>().getBoolTheme()
          ? ThemeMode.light
          : ThemeMode.dark,
      initialRoute: "/",
      routes: {
        "/": (context) => const NewsScreen(),
        "/settigns": (context) => const SettignsScreen(),
        "/article": (context) => const ArticleScreen(),
        "/favorites": (context) => const FavoritesScreen(),
      },
    );
  }
}
