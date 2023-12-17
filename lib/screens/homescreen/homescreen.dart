import 'package:christabodeadmin/screens/devotional/devotional_screen.dart';
import 'package:christabodeadmin/screens/events/events_screen.dart';
import 'package:christabodeadmin/screens/hymn/hymn_screen.dart';
import 'package:christabodeadmin/screens/prayer/prayer_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const id = "homescreen";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
        height: 200,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, DevotionalScreen.id);
                },
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Add Devotional"),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, PrayerScreen.id);
                },
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Add Prayers"),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, EventScreen.id);
                },
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Add Event"),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, HymnScreen.id);
                },
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Add Hymn"),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
