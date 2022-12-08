import 'package:christabodeadmin/providers/devotional_provider.dart';
import 'package:christabodeadmin/providers/prayer_provider.dart';
import 'package:christabodeadmin/repositories/devotional_repository.dart';
import 'package:christabodeadmin/repositories/events_repository.dart';
import 'package:christabodeadmin/repositories/prayer_repository.dart';
import 'package:christabodeadmin/screens/events/events_screen.dart';
import 'package:christabodeadmin/screens/homescreen/homescreen.dart';
import 'package:christabodeadmin/screens/prayer/prayer_screen.dart';
import 'package:christabodeadmin/services/devotional/devotional_firestore_service.dart';
import 'package:christabodeadmin/services/events/events_firestore_service.dart';
import 'package:christabodeadmin/services/prayer/prayer_firestore_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/provider.dart';

import 'core/connection_checker/connection_checker.dart';
import 'firebase_options.dart';
import 'providers/event_provider.dart';
import 'screens/devotional/devotional_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ///Devotional Dependencies//
  final DevotionalFirestoreService _devotionalFirestoreService =
      DevotionalFirestoreService();
  late final DevotionalRepository _devotionalRepository;

  ///Prayer Dependencies//
  final PrayerFirestoreService _prayerFirestoreService =
      PrayerFirestoreService();
  late final PrayerRepository _prayerRepository;

  ///Event Dependencies///
  final EventsFirestoreService _eventsFirestoreService =
      EventsFirestoreService();
  late final EventsRepository _eventsRepository;

  final ConnectionChecker _connectionChecker =
      ConnectionCheckerImplementation(InternetConnectionCheckerPlus());

  @override
  void initState() {
    _devotionalRepository = DevotionalRepositoryImplementation(
      devotionalFirestoreService: _devotionalFirestoreService,
      connectionChecker: _connectionChecker,
    );

    _prayerRepository = PrayerRepositoryImplementation(
        prayerFirestoreService: _prayerFirestoreService,
        connectionChecker: _connectionChecker);

    _eventsRepository = EventsRepositoryImplementation(
        eventsFirestoreService: _eventsFirestoreService,
        connectionChecker: _connectionChecker);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DevotionalProvider>(
            create: (context) => DevotionalProvider(_devotionalRepository)),
        ChangeNotifierProvider<PrayerProvider>(
            create: (context) => PrayerProvider(_prayerRepository)),
        ChangeNotifierProvider<EventProvider>(
            create: (context) => EventProvider(_eventsRepository))
      ],
      child: MaterialApp(
        title: 'Christ Abode Ministries Admin App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const DevotionalScreen(),
        routes: {
          HomeScreen.id: (context) => const HomeScreen(),
          DevotionalScreen.id: (context) => const DevotionalScreen(),
          PrayerScreen.id: (context) => const PrayerScreen(),
          EventScreen.id: (context) => const EventScreen(),
        },
      ),
    );
  }
}
