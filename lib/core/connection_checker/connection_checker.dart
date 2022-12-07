import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class ConnectionChecker {
  Future<bool> get isConnected;
}

class ConnectionCheckerImplementation implements ConnectionChecker {
  final InternetConnectionCheckerPlus internetConnectionChecker;

  ConnectionCheckerImplementation(this.internetConnectionChecker);

  @override
  Future<bool> get isConnected => internetConnectionChecker.hasConnection;
}
