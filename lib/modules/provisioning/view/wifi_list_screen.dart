import 'package:bms_app/modules/provisioning/models/wifi.dart';
import 'package:bms_app/modules/provisioning/provider/wifi_list_provider.dart';
import 'package:bms_app/modules/provisioning/widgets/password_dialog_widget.dart';
import 'package:bms_app/modules/provisioning/widgets/wifi_card.dart';
import 'package:bms_app/modules/provisioning/widgets/wifi_list_loading_widget.dart';
import 'package:bms_app/modules/provisioning/widgets/wifi_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:plugin_wifi_connect/plugin_wifi_connect.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';

class WifiListScreen extends HookConsumerWidget {
  const WifiListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listValue = ref.watch(wifiListProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Choose device wifi')),
      body: switch (listValue) {
        AsyncData(:final value) => WifiListWidget(
          value: value,
          onRefresh: () => ref.invalidate(wifiListProvider),
          onItemTap: (WiFiAccessPoint item) async {
            final security = item.getSecurity();
            String? password;
            if (security != NetworkSecurity.NONE) {
              password = await showDialog(
                context: context,
                builder: (_) {
                  return PasswordDialogWidget(item: item);
                },
              );
              if (password == null) {
                return;
              }
            }

            if (await WiFiForIoTPlugin.connect(
              password: password,
              item.ssid,
              security: security,
            ) && context.mounted) {
              context.push('/provisioning/settings');
            }
          },
        ),

        AsyncError(:final error) => Text('Error scanning networks: $error'),

        _ => WifiListLoadingWidget(),
      },
    );
  }
}
