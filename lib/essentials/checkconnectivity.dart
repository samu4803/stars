import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class CheckConnectivity extends StatelessWidget {
  CheckConnectivity(
      {super.key, required this.widgetModel, required this.refresh});
  final Function refresh;
  final Widget widgetModel;
  final connectivityStatus = Connectivity();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (ctx, snapshot) {
        if (snapshot.data == ConnectivityResult.mobile ||
            snapshot.data == ConnectivityResult.wifi ||
            snapshot.data == ConnectivityResult.ethernet ||
            snapshot.data == ConnectivityResult.vpn) {
          return widgetModel;
        } else {
          final List<String> messages = [
            "Hi ",
            "Check Your Internet",
            "let See",
            "Error 6969",
            "Pay Your Bills",
            "Get Money",
            "Earn money",
            "Touch Grass",
            "switch off the Phone",
          ];
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(messages[Random().nextInt(messages.length)]),
                ElevatedButton(
                    onPressed: () => refresh(), child: const Text("Refresh"))
              ],
            ),
          );
        }
      },
      stream: connectivityStatus.checkConnectivity().asStream(),
    );
  }
}
