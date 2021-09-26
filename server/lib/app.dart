import 'dart:io';

import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:server/toolkits/network/network_toolkit.dart';
import 'package:server/toolkits/redux/redux_toolkit.dart';
import 'package:vrouter/vrouter.dart';

class ServerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MacosApp(
      title: 'Dev Toolkit Server',
      themeMode: ThemeMode.light,
      darkTheme: MacosThemeData.dark(),
      theme: MacosThemeData.light(),
      home: VRouter(
        themeMode: ThemeMode.light,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        routes: [
          VNester(
            path: '/',
            widgetBuilder: (child) => HomePage(child),
            nestedRoutes: [
              VWidget(path: null, widget: Container()),
              VWidget(path: 'redux', widget: ReduxToolkit()),
              VWidget(path: 'network', widget: NetworkToolkit()),
            ],
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final Widget child;

  const HomePage(this.child, {Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  bool isRailExpanded = false;

  @override
  Widget build(BuildContext context) {
    var sidebarItems = {
      'Redux Inspector': Icons.account_balance_wallet,
      'Network Inspector': Icons.account_balance_wallet,
    };
    return MacosWindow(
      sidebar: Sidebar(
        builder: (context, scrollController) {
          return SidebarItems(
            currentIndex: index,
            onChanged: (newIndex) => onSidebarClicked(newIndex, context),
            items: sidebarItems.entries.map((e) {
              return SidebarItem(label: Text(e.key), leading: Icon(e.value));
            }).toList(),
          );
        },
        isResizable: true,
        minWidth: 240,
        bottom: HelpButton(onPressed: () => showNetworkInterfaces(context)),
      ),
      child: MacosScaffold(
        children: [
          ContentArea(builder: (context, scrollController) {
            return widget.child;
          }),
        ],
      ),
    );
  }

  void onSidebarClicked(int newIndex, BuildContext context) {
    var route = ['/redux', '/network'][newIndex];
    context.vRouter.to(route);
    setState(() => index = newIndex);
  }

  Future<void> showNetworkInterfaces(BuildContext context) async {
    var list = await NetworkInterface.list();
    showDialog(
        context: context,
        builder: (context) {
          return MacosAlertDialog(
            appIcon: FlutterLogo(),
            primaryButton: PushButton(
              onPressed: () => Navigator.pop(context),
              buttonSize: ButtonSize.small,
              child: Text('Ok'),
            ),
            title: Text(
              'Connect using any of the following IP Addresses in the Same Network',
            ),
            message: Column(
              children: [
                SizedBox(height: 16),
                ...getInterfacesListWidgets(list),
                SizedBox(height: 16),
              ],
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
