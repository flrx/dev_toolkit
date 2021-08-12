import 'package:dev_toolkit/src/toolkits/network/request_info.dart';
import 'package:dev_toolkit/src/toolkits/network/response_info.dart';

class NetworkLogger {
  Map<String, RequestInfo> requestLogs = {};
  Map<String, ResponseInfo> responseLogs = {};

  static NetworkLogger get instance {
    _instance ??= NetworkLogger._();
    return _instance!;
  }

  static NetworkLogger? _instance;

  NetworkLogger._();
}
