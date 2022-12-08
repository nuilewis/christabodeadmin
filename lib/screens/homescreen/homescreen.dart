import 'package:christabodeadmin/screens/devotional/devotional_screen.dart';
import 'package:christabodeadmin/screens/events/events_screen.dart';
import 'package:christabodeadmin/screens/prayer/prayer_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const id = "homescreen";
  const HomeScreen({Key? key}) : super(key: key);

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
            )
          ],
        ),
      )),
    );
  }
}
