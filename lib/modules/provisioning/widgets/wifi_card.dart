import 'package:bms_app/modules/provisioning/widgets/password_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';

class WifiCard extends StatelessWidget {
  const WifiCard({
    super.key,
    required this.onTap,
    required this.item,
    required this.security,
  });
  final NetworkSecurity security;
  final VoidCallback onTap;
  final WiFiAccessPoint item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSecured = security != NetworkSecurity.NONE;
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.wifi, color: theme.primaryColor),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(item.ssid)],
                ),
              ),
              if (isSecured) Icon(Icons.lock, color: theme.primaryColor),
            ],
          ),
        ),
      ),
    );
  }
}
