import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

class ConnectivityPage extends StatefulWidget {
  const ConnectivityPage({Key? key}) : super(key: key);

  @override
  _ConnectivityPageState createState() => _ConnectivityPageState();
}

class _ConnectivityPageState extends State<ConnectivityPage> {
  List<NetworkInterface>? list;

  @override
  void initState() {
    super.initState();

    NetworkInterface.list().then((result) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        setState(() => list = result);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MacosScaffold(
        titleBar: TitleBar(
          title: Text('Network Interfaces'),
        ),
        children: [
          ContentArea(
            builder: (BuildContext context, ScrollController scrollController) {
              return ListView(
                padding: EdgeInsets.all(24),
                children: [
                  Text(
                    'Connect using any of the following IP Addresses in the Same Network',
                  ),
                  SizedBox(height: 16),
                  if (list != null) ...getInterfacesListWidgets(),
                  SizedBox(height: 16),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Iterable<Widget> getInterfacesListWidgets() {
    return list!.expand((interface) {
      return interface.addresses.map((address) {
        return MacosListTile(
          title: SelectableText(address.address),
          subtitle: Text(interface.name),
        );
      }).toList();
    });
  }
}
