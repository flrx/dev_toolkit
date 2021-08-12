class ResponseInfo {
  String requestId;
  DateTime timeStamp;
  int? statusCode;
  String? statusReason;
  Map<String, dynamic>? headers;
  dynamic body;

  ResponseInfo({
    required this.requestId,
    required this.timeStamp,
    this.statusCode,
    this.statusReason,
    this.headers,
    this.body,
  });

  Map<String, dynamic> toJson() {
    if (headers == null) {
      headers = new Map();
    }
    
    return {
      'requestId': requestId,
      'timeStamp': timeStamp,
      'statusCode': statusCode,
      'statusReason': statusReason,
      'headers': headers,
      'body': body,
    };
  }
}
