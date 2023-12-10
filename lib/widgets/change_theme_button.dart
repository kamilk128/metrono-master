import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  const ChangeThemeButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<MyAppState>(context);

    return Switch.adaptive(
      value: themeProvider.themeMode == ThemeMode.dark,
      trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
      onChanged: (value) {
        final provider = Provider.of<MyAppState>(context, listen: false);
        provider.toggleTheme(value);
      },
      inactiveThumbColor: theme.colorScheme.onPrimary,
      activeColor: theme.colorScheme.secondary,
    );
  }
}
