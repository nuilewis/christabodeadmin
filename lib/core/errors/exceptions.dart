class ConnectionException implements Exception {
  late String errorMessage;

  ConnectionException({this.errorMessage = "No Network Access"});
  @override
  String toString() => errorMessage;
}
