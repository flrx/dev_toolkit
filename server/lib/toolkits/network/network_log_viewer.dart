import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:server/plugins/network_plugin.dart';
import 'package:server/toolkits/network/request_info.dart';
import 'package:server/toolkits/network/response_info.dart';

class NetworkLogViewer extends StatefulWidget {
  final String requestId;
  final RequestInfo requestInfo;
  final ResponseInfo? responseInfo;

  NetworkLogViewer({Key? key, required this.requestId})
      : requestInfo = NetworkPlugin.requestLogs[requestId]!,
        responseInfo = NetworkPlugin.responseLogs[requestId],
        super(key: key);

  @override
  _NetworkLogViewerState createState() => _NetworkLogViewerState();
}

class _NetworkLogViewerState extends State<NetworkLogViewer> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          labelColor: Theme.of(context).textTheme.bodyText1?.color,
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
        body: ListTileTheme(
          dense: true,
          child: TabBarView(
            children: [
              buildRequest(),
              buildResponse(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRequest() {
    var response = widget.requestInfo;
    return ListView.separated(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: Builder(builder: (context) {
            var uri = Uri.parse(response.uri);

            switch (index) {
              case 0:
                return ExpansionTile(
                  title: buildHeading('Info'),
                  children: [
                    ListTile(
                      leading: Text(response.method),
                      title: Text(uri.path),
                      subtitle: Text(uri.host),
                    ),
                    ListTile(
                      title: Text('Request ID'),
                      subtitle: Text(response.requestId),
                    ),
                    ListTile(
                      title: Text('Time'),
                      subtitle: Text(response.timeStamp.toIso8601String()),
                    ),
                  ],
                );
              case 1:
                return ExpansionTile(
                  title: buildHeading('Headers'),
                  children: [
                    buildHeaders(response.headers),
                  ],
                );
              case 2:
                return ExpansionTile(
                  initiallyExpanded: true,
                  title: buildHeading('Body'),
                  children: [
                    isJsonBody(response.headers)
                        ? JsonViewer(
                            jsonDecode(response.body),
                          )
                        : Text(response.body),
                  ],
                );
            }
            return Container();
          }),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }

  Widget buildResponse() {
    var response = widget.responseInfo;
    if (response == null) {
      return Container(child: Text('Response not received'));
    }

    var headers = response.headers;
    return ListView.separated(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: Builder(builder: (context) {
            switch (index) {
              case 0:
                return ExpansionTile(
                  title: buildHeading('Info'),
                  children: [
                    ListTile(
                      title: Text('Request ID'),
                      subtitle: Text(response.requestId),
                    ),
                    ListTile(
                      title: Text('Time'),
                      subtitle: Text(response.timeStamp.toIso8601String()),
                    ),
                    if (response.statusCode != null)
                      ListTile(
                        title: Text('Status'),
                        subtitle: Text(response.statusCode!.toString()),
                      ),
                    if (response.statusReason != null)
                      ListTile(
                        title: Text('Status Reason'),
                        subtitle: Text(response.statusReason!),
                      ),
                  ],
                );
              case 1:
                return ExpansionTile(
                  title: buildHeading('Headers'),
                  children: [
                    buildHeaders(headers),
                  ],
                );
              case 2:
                return ExpansionTile(
                  initiallyExpanded: true,
                  title: buildHeading('Body'),
                  children: [
                    isJsonBody(headers)
                        ? JsonViewer(
                            jsonDecode(response.body),
                          )
                        : Text(response.body),
                  ],
                );
            }
            return Container();
          }),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
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
      children: headers.entries.map((e) {
        return ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          title: Text(e.key),
          subtitle: Text(e.value),
        );
      }).toList(),
    );
  }

  Widget buildHeading(String heading) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.subtitle2,
    );
  }
}
