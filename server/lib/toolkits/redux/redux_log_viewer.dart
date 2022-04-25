import 'dart:convert';

import 'package:dev_toolkit/dev_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:pretty_diff_text/pretty_diff_text.dart';

class ReduxLogViewer extends StatelessWidget {
  final ReduxLog log;

  const ReduxLogViewer({Key? key, required this.log}) : super(key: key);

  final encoder = const JsonEncoder.withIndent('  ');

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: TabBar(
          labelColor: Theme.of(context).textTheme.bodyText1?.color,
          tabs: [
            Container(
              height: kToolbarHeight * 0.7,
              alignment: Alignment.center,
              child: Text('Action'),
            ),
            Container(
              height: kToolbarHeight * 0.7,
              alignment: Alignment.center,
              child: Text('State Diff'),
            ),
            Container(
              height: kToolbarHeight * 0.7,
              alignment: Alignment.center,
              child: Text('State Split'),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            buildAction(),
            buildState(context),
            buildStateSplit(context),
          ],
        ),
      ),
    );
  }

  Widget buildAction() {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        ListTile(
          title: Text('Type'),
          subtitle: Text(
            log.action.type,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Divider(),
        ListTile(
          title: Text('Payload'),
          subtitle: JsonViewer(log.action.payload),
        ),
      ],
    );
  }

  Widget buildState(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: PrettyDiffText(
        textAlign: TextAlign.start,
        oldText: encoder.convert(log.oldState),
        newText: encoder.convert(log.newState),
        diffCleanupType: DiffCleanupType.SEMANTIC,
        defaultTextStyle: Theme.of(context).textTheme.bodyText1!,
        addedTextStyle: TextStyle(
          color: Colors.green,
          backgroundColor: Colors.green.shade50,
        ),
        deletedTextStyle: TextStyle(
          color: Colors.red,
          backgroundColor: Colors.red.shade50,
        ),
      ),
    );
  }

  Align buildHeader(String data) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(data),
    );
  }

  Widget buildStateSplit(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: buildStateAsJson(log.oldState),
          ),
        ),
        VerticalDivider(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: buildStateAsJson(log.newState),
          ),
        ),
      ],
    );
  }

  Widget buildStateAsJson(oldState) {
    return oldState is Map<String, dynamic> || oldState is List<dynamic>
        ? JsonViewer(oldState)
        : Text(oldState.toString());
  }
}
