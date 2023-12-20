import 'package:christabodeadmin/screens/devotional/devotional_screen.dart';
import 'package:christabodeadmin/screens/events/events_screen.dart';
import 'package:christabodeadmin/screens/hymn/hymn_screen.dart';
import 'package:christabodeadmin/screens/prayer/prayer_screen.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const id = "homescreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedPageIndex = 0;

  final PageStorageBucket bucket = PageStorageBucket();

  List<Widget> pages = [
    const DevotionalScreen(
      key: PageStorageKey(DevotionalScreen.id),
    ),
    const PrayerScreen(
      key: PageStorageKey(PrayerScreen.id),
    ),
    const EventScreen(
      key: PageStorageKey(EventScreen.id),
    ),
    const HymnScreen(
      key: PageStorageKey(HymnScreen.id),
    )
  ];

  @override
  Widget build(BuildContext context) {
    //print(MediaQuery.sizeOf(context).width);
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            leading: const SizedBox(
              height: 32,
            ),

            minExtendedWidth: 200,
            selectedIconTheme: Theme.of(context)
                .iconTheme
                .copyWith(color: Theme.of(context).colorScheme.primary),
            unselectedLabelTextStyle: Theme.of(context).textTheme.bodyMedium,
            selectedLabelTextStyle: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Theme.of(context).colorScheme.primary),
            extended: MediaQuery.sizeOf(context).width > 850 ? true : false,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            onDestinationSelected: (int index) {
              setState(() {
                selectedPageIndex = index;
              });
            },
            selectedIndex: selectedPageIndex,
            indicatorColor: Theme.of(context).cardColor,
            // indicatorShape: ContinuousRectangleBorder(
            //     borderRadius: BorderRadius.circular(16)),
            destinations: const [
              NavigationRailDestination(
                  selectedIcon: Icon(FluentIcons.reading_mode_mobile_24_filled),
                  icon: Icon(FluentIcons.reading_mode_mobile_24_regular),
                  label: Text("Devotional")),
              NavigationRailDestination(
                  selectedIcon: Icon(FluentIcons.thinking_24_filled),
                  icon: Icon(FluentIcons.thinking_24_regular),
                  label: Text("Prayer")),
              NavigationRailDestination(
                  selectedIcon: Icon(FluentIcons.alert_24_filled),
                  icon: Icon(FluentIcons.alert_24_regular),
                  label: Text("Events")),
              NavigationRailDestination(
                  selectedIcon: Icon(FluentIcons.music_note_1_24_filled),
                  icon: Icon(FluentIcons.music_note_1_24_regular),
                  label: Text("Hymn")),
            ],
          ),
          Expanded(
            child: PageStorage(bucket: bucket, child: pages[selectedPageIndex]),
          ),
        ],
      ),
    );
  }
}
