import 'dart:async';

import 'package:server/plugins/plugin.dart';
import 'package:server/toolkits/network/request_info.dart';
import 'package:server/toolkits/network/response_info.dart';

class NetworkPlugin extends Plugin {
  static Map<String, RequestInfo> requestLogs = {};
  static Map<String, ResponseInfo> responseLogs = {};

  static StreamController<Map<String, RequestInfo>> _controller =
      StreamController.broadcast();
  static Stream<Map<String, RequestInfo>> logsStream = _controller.stream;

  @override
  String get name => 'network';

  @override
  Future<Map<String, dynamic>> handleBody(
    Map<String, dynamic> requestBody,
  ) async {
    var details = requestBody['details'];
    /// "requestId": uniqueId,
    /// "timeStamp": DateTime.now().toIso8601String(),
    /// "uri": '${request.uri}',
    /// "headers": headers,
    /// "method": request.method,
    /// "body": body,
    /// "type": "request",
    details['type'] == 'request'
        ? createRequestAndAdd(details)
        : createResponseAndAdd(details);

    return {'status': 'Success'};
  }

  void createRequestAndAdd(Map<String, dynamic> details) {
    var log = RequestInfo(
      requestId: details['requestId'],
      timeStamp: DateTime.parse(details['timeStamp']),
      uri: details['uri'],
      headers: details['headers'],
      method: details['method'],
      body: details['body'],
    );
    requestLogs[log.requestId] = log;
    _controller.add(requestLogs);
  }

  createResponseAndAdd(Map<String, dynamic> details) {
    var log = ResponseInfo(
      requestId: details['requestId'],
      timeStamp: DateTime.parse(details['timeStamp']),
      headers: details['headers'],
      body: details['body'],
      statusCode: details['statusCode'],
      statusReason: details['statusReason'],
    );

    responseLogs[log.requestId] = log;
  }
}
