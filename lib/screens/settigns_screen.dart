import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pr1_news_app/data/local_storage.dart';

import '../generated/l10n.dart';

class SettignsScreen extends StatefulWidget {
  const SettignsScreen({super.key});

  @override
  State<SettignsScreen> createState() => _SettignsScreenState();
}

class _SettignsScreenState extends State<SettignsScreen> {
  final List<bool> _selectedLanguage = <bool>[true, false];
  final List<String> _languages = ["ru", "en"];

  late bool isLightTheme;

  @override
  void initState() {
    isLightTheme = GetIt.I<LocalStorage>().getBoolTheme();

    String currentLocale = GetIt.I<LocalStorage>().getLocale();
    for (int i = 0; i < _selectedLanguage.length; i++) {
      _selectedLanguage[i] = _languages[i] == currentLocale;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).settings,
          ),
          foregroundColor: theme.colorScheme.surface,
          backgroundColor: theme.colorScheme.primary,
        ),
        body: ListView(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          physics: ClampingScrollPhysics(),
          children: [
            Container(
              constraints: BoxConstraints(minHeight: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).darkTheme,
                    style: theme.textTheme.titleMedium,
                  ),
                  Switch.adaptive(
                    value: !isLightTheme,
                    onChanged: (bool newValue) {
                      isLightTheme = !newValue;
                      GetIt.I<LocalStorage>().saveBoolTheme(isLightTheme);
                    },
                  )
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints(minHeight: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).languageSelection,
                    style: theme.textTheme.titleMedium,
                  ),
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(18),
                    isSelected: _selectedLanguage,
                    onPressed: (index) => setState(() {
                      for (int i = 0; i < _selectedLanguage.length; i++) {
                        _selectedLanguage[i] = i == index;

                        if (i == index) {
                          GetIt.I<LocalStorage>().saveLocale(_languages[i]);
                        }
                      }
                    }),
                    children: [
                      Text(_languages[0].toUpperCase()),
                      Text(_languages[1].toUpperCase()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
