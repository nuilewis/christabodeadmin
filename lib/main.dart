import 'package:christabodeadmin/providers/devotional_provider.dart';
import 'package:christabodeadmin/repositories/devotional_repository.dart';
import 'package:christabodeadmin/screens/homescreen/homescreen.dart';
import 'package:christabodeadmin/services/devotional/devotional_firestore_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/provider.dart';

import 'core/connection_checker/connection_checker.dart';
import 'firebase_options.dart';
import 'screens/devotional_screen/devotional_screen.dart';

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
  // This widget is the root of your application.
  final DevotionalFirestoreService _devotionalFirestoreService =
      DevotionalFirestoreService();
  late final DevotionalRepository _devotionalRepository;

  @override
  void initState() {
    _devotionalRepository = DevotionalRepositoryImplementation(
      devotionalFirestoreService: _devotionalFirestoreService,
      connectionChecker:
          ConnectionCheckerImplementation(InternetConnectionCheckerPlus()),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DevotionalProvider>(
            create: (context) => DevotionalProvider(_devotionalRepository))
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
        },
      ),
    );
  }
}
