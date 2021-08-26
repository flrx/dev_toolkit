class RequestInfo {
  final String requestId;
  final DateTime timeStamp;
  final Map<String, dynamic> headers;
  final String method;
  final String uri;
  final dynamic body;

  RequestInfo({
    required this.requestId,
    required this.timeStamp,
    required this.headers,
    required this.method,
    required this.uri,
    this.body,
  });

  Map<String, dynamic> toJson() {
    return {
      'timeStamp': timeStamp,
      'headers': headers,
      'method': method,
      'uri': uri,
      'body': body,
    };
  }
}
