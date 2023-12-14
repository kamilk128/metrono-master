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
    var activeLanguage = appState.settings.language;

    final theme = Theme.of(context);
    final headerStyle = theme.textTheme.headlineSmall!.copyWith(color: theme.colorScheme.onBackground);

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
              // TODO handle sound change
              print(value);
            },
            items: ['sound 1', 'sound 2'].map((sound) {
              return DropdownMenuItem<String>(
                value: sound,
                child: Text(
                  sound,
                  style: headerStyle,
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
            onChanged: (String? value) {
              setState(() {
                appState.setLanguage(value as String);
              });
            },
            value: activeLanguage,
            items: Settings.availableLanguages.map((language) {
              return DropdownMenuItem<String>(
                value: language,
                child: Text(
                  language,
                  style: headerStyle,
                ),
              );
            }).toList(),
          ),
        ),
      ]),
    );
  }
}
