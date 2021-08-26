import 'dart:io';

import 'package:flutter/material.dart';
import 'package:server/toolkits/network/network_toolkit.dart';
import 'package:server/toolkits/redux/redux_toolkit.dart';

class ServerApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dev Toolkit Server',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  bool isRailExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: isRailExpanded,
            elevation: 8,
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                setState(() {
                  isRailExpanded = !isRailExpanded;
                });
              },
            ),
            trailing: IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () => showNetworkInterfaces(context),
            ),
            onDestinationSelected: (newIndex) {
              setState(() => index = newIndex);
            },
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.account_balance_wallet),
                label: Text('Redux Inspector'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.network_check_outlined),
                label: Text('Network Inspector'),
              ),
            ],
            selectedIndex: index,
          ),
          VerticalDivider(color: Colors.transparent),
          Expanded(
            child: IndexedStack(
              index: index,
              children: [
                ReduxToolkit(),
                NetworkToolkit(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> showNetworkInterfaces(BuildContext context) async {
    var list = await NetworkInterface.list();

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Connect using any of the following IP Addresses in the Same Network',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(height: 16),
                  ...getInterfacesListWidgets(list),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Ok'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Iterable<Widget> getInterfacesListWidgets(List<NetworkInterface> list) {
    return list.expand((interface) {
      return interface.addresses.map((address) {
        return SelectableText(
          "${address.address} (${interface.name})",
        );
      }).toList();
    });
  }
}
