import 'dart:convert';

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/settings.dart';
import '../widgets/change_theme_button.dart';
import '../main.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var activeSound = appState.settings.sound;
    var activeLanguage = appState.settings.language;
    var activeDelay = appState.settings.delay;

    final theme = Theme.of(context);
    final headerStyle = theme.textTheme.headlineSmall!.copyWith(color: theme.colorScheme.onBackground);
    final bodyStyle = theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onBackground);

    return FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString('AssetManifest.json'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const ListTile();
          } else {
            final assetManifest = snapshot.data;
            final Map<String, dynamic> manifestMap = json.decode(assetManifest);
            final List<String> soundsList = manifestMap.keys
                .where((String key) => key.contains('lo.wav'))
                .map((String key) => key.substring(key.lastIndexOf('/') + 1, key.lastIndexOf('.') - 3))
                .toList();
            return Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(children: [
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.darkMode,
                    style: headerStyle,
                  ),
                  trailing: const ChangeThemeButtonWidget(),
                ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.sound,
                    style: headerStyle,
                  ),
                  trailing: DropdownButton<String>(
                    onChanged: (value) {
                      setState(() {
                        appState.setSound(value as String);
                      });
                    },
                    value: activeSound,
                    alignment: AlignmentDirectional.center,
                    items: soundsList.map((sound) {
                      return DropdownMenuItem<String>(
                        value: sound,
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          sound,
                          style: bodyStyle,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.language,
                    style: headerStyle,
                  ),
                  trailing: DropdownButton<String>(
                    onChanged: (value) {
                      setState(() {
                        appState.setLanguage(value as String);
                      });
                    },
                    value: activeLanguage,
                    alignment: AlignmentDirectional.center,
                    items: Settings.availableLanguages.map((language) {
                      return DropdownMenuItem<String>(
                        value: language,
                        alignment: AlignmentDirectional.center,
                        child: CountryFlag.fromCountryCode(language == 'en' ? 'gb' : language, height: 32, width: 32),
                      );
                    }).toList(),
                  ),
                ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.delay,
                    style: headerStyle,
                  ),
                  trailing: DropdownButton<int>(
                    onChanged: (value) {
                      setState(() {
                        appState.setDelay(value);
                      });
                    },
                    value: activeDelay,
                    alignment: AlignmentDirectional.center,
                    items: [0, 25, 50, 75, 100, 125, 150, 175, 200].map((delay) {
                      return DropdownMenuItem<int>(
                        value: delay,
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          "${delay}ms",
                          style: bodyStyle,
                        ),
                      );
                    }).toList(),
                  ),
                )
              ]),
            );
          }
        });
  }
}
