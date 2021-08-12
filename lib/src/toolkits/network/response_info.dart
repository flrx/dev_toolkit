class ResponseInfo {
  final String requestId;
  final DateTime timeStamp;
  final int? statusCode;
  final String? statusReason;
  final Map<String, dynamic>? headers;
  final dynamic body;

  ResponseInfo({
    required this.requestId,
    required this.timeStamp,
    this.statusCode,
    this.statusReason,
    this.headers,
    this.body,
  });

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'timeStamp': timeStamp,
      'statusCode': statusCode,
      'statusReason': statusReason,
      'headers': headers ?? Map(),
      'body': body,
    };
  }
}
