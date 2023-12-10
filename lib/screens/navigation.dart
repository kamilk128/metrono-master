import 'package:flutter/material.dart';
import 'package:metrono_master/screens/metronome_v2.dart';
import 'package:metrono_master/screens/rhythm_list_view.dart';
import 'package:metrono_master/screens/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'metronome.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const MetronomeControl();
        break;
      case 1:
        page = const MetronomeV2();
        break;
      case 2:
        page = const RhythmListView();
        break;
      case 3:
        page = const Settings();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    void onItemTapped(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    return Scaffold(
      body: Center(
        child: page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.colorScheme.primary,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            label: AppLocalizations.of(context)!.metronome,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            label: AppLocalizations.of(context)!.metronome,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.queue_music),
            label: AppLocalizations.of(context)!.rhythmList,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: AppLocalizations.of(context)!.settings,
          ),
        ],
        currentIndex: selectedIndex,
        unselectedItemColor: theme.colorScheme.onPrimary,
        selectedItemColor: theme.colorScheme.secondary,
        onTap: onItemTapped,
      ),
    );
  }
}
