import 'package:dev_toolkit/dev_toolkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pretty_diff_text/pretty_diff_text.dart';

class ReduxLogViewer extends StatelessWidget {
  final ReduxLog log;

  const ReduxLogViewer({Key? key, required this.log}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(log.action.type),
          bottom: TabBar(
            tabs: [
              Container(
                height: kToolbarHeight * 0.7,
                alignment: Alignment.center,
                child: Text('Action'),
              ),
              Container(
                height: kToolbarHeight * 0.7,
                alignment: Alignment.center,
                child: Text('State'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildAction(),
            buildState(context),
          ],
        ),
      ),
    );
  }

  Widget buildAction() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text('Type: '),
              Text(
                log.action.type,
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Row(
            children: [
              Text('Payload: '),
              Text(log.action.payload.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildState(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: PrettyDiffText(
        textAlign: TextAlign.start,
        oldText: log.oldState,
        newText: log.newState,
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
}
