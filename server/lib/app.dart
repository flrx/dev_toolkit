import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:server/connectivity.dart';
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
              VWidget(
                path: null,
                widget: ConnectivityPage(),
              ),
              VWidget(
                path: 'redux',
                widget: ReduxToolkit(),
              ),
              VWidget(
                path: 'network',
                widget: NetworkToolkit(),
              ),
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

  @override
  Widget build(BuildContext context) {
    var sidebarItems = {
      'Home': Icons.home,
      'Redux Inspector': Icons.account_balance_wallet,
      'Network Inspector': Icons.wifi,
    }
        .entries
        .map((e) => SidebarItem(label: Text(e.key), leading: Icon(e.value)))
        .toList();

    return MacosWindow(
      titleBar: TitleBar(title: sidebarItems[index].label),
      sidebar: Sidebar(
        builder: (context, scrollController) {
          return SidebarItems(
            currentIndex: index,
            onChanged: (newIndex) => onSidebarClicked(newIndex, context),
            items: sidebarItems,
          );
        },
        isResizable: true,
        minWidth: 240,
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
    var route = ['/', '/redux', '/network'][newIndex];
    context.vRouter.to(route);
    setState(() => index = newIndex);
  }
}
