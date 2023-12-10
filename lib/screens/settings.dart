import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/change_theme_button.dart';
import '../main.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var languages = appState.languages;
    var activeLanguage = appState.activeLanguage;

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Column(children: [
        ListTile(
          title: Text(
            AppLocalizations.of(context)!.darkMode,
            style: TextStyle(color: theme.colorScheme.onBackground),
          ),
          trailing: const ChangeThemeButtonWidget(),
        ),
        ListTile(
          title: Text(
            AppLocalizations.of(context)!.sound,
            style: TextStyle(color: theme.colorScheme.onBackground),
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
                  style: TextStyle(color: theme.colorScheme.onBackground),
                ),
              );
            }).toList(),
          ),
        ),
        ListTile(
          title: Text(
            AppLocalizations.of(context)!.language,
            style: TextStyle(color: theme.colorScheme.onBackground),
          ),
          trailing: DropdownButton<String>(
            onChanged: (String? value) {
              setState(() {
                appState.setLanguage(value as String);
              });
            },
            value: activeLanguage,
            items: languages // Add your language options here
                .map((language) {
              return DropdownMenuItem<String>(
                value: language,
                child: Text(
                  language,
                  style: TextStyle(color: theme.colorScheme.onBackground),
                ),
              );
            }).toList(),
          ),
        ),
      ]),
    );
  }
}
