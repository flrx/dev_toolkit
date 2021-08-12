import 'package:dev_toolkit/src/toolkits/network/network_toolkit.dart';
import 'package:dev_toolkit/src/toolkits/redux/redux_toolkit.dart';
import 'package:flutter/material.dart';

class DevToolkit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: Text('Redux Toolkit'),
            onTap: () => openPage(context, ReduxToolkit()),
          ),
          ListTile(
            title: Text('Network Inspector'),
            onTap: () => openPage(context, NetworkToolkit()),
          ),
        ],
      ),
    );
  }

  void openPage(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }
}
