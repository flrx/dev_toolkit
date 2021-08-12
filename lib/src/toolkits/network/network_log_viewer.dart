import 'dart:convert';

import 'package:dev_toolkit/src/toolkits/network/network_log.dart';
import 'package:dev_toolkit/src/toolkits/network/request_info.dart';
import 'package:dev_toolkit/src/toolkits/network/response_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';

class NetworkLogViewer extends StatelessWidget {
  final String requestId;
  final RequestInfo requestInfo;
  final ResponseInfo? responseInfo;

  NetworkLogViewer({Key? key, required this.requestId})
      : requestInfo = NetworkLogger.instance.requestLogs[requestId]!,
        responseInfo = NetworkLogger.instance.responseLogs[requestId],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Network Request'),
          bottom: TabBar(
            tabs: [
              Container(
                height: kToolbarHeight * 0.7,
                alignment: Alignment.center,
                child: Text('Request'),
              ),
              Container(
                height: kToolbarHeight * 0.7,
                alignment: Alignment.center,
                child: Text('Response'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildRequest(),
            buildResponse(),
          ],
        ),
      ),
    );
  }

  Widget buildRequest() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Headers'),
          ...requestInfo.headers.entries.map((e) {
            return Text(e.key + ": " + e.value.toString());
          }).toList(),
          SizedBox(height: 16),
          Text('Body'),
          isJsonBody(requestInfo.headers)
              ? JsonViewer(
                  jsonDecode(requestInfo.body),
                )
              : Text(requestInfo.body),
        ],
      ),
    );
  }

  Widget buildResponse() {
    var response = responseInfo;
    if (response == null) {
      return Container(
        child: Text('Response not received'),
      );
    }
    var headers = response.headers;
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Headers'),
          buildHeaders(headers),
          SizedBox(height: 16),
          Text('Body'),
          isJsonBody(headers)
              ? JsonViewer(
                  jsonDecode(response.body),
                )
              : Text(response.body),
        ],
      ),
    );
  }

  bool isJsonBody(Map<String, dynamic>? headers) {
    return headers?.containsKey('content-type') == true &&
        headers!['content-type'].startsWith('application/json');
  }

  Widget buildHeaders(Map<String, dynamic>? headers) {
    if (headers == null) {
      return Text('No headers');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: headers.entries
          .map((e) => Text(e.key + ": " + e.value.toString()))
          .toList(),
    );
  }
}
