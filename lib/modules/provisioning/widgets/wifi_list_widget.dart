import 'package:bms_app/modules/provisioning/widgets/wifi_card.dart';
import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';

class WifiListWidget extends StatelessWidget {
  const WifiListWidget({
    super.key,
    required this.onRefresh,
    required this.value, required this.onItemTap,
  });

  final List<WiFiAccessPoint> value;
final void Function(WiFiAccessPoint item) onItemTap;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {

    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      child: ListView.separated(
        itemBuilder: (context, index) {
          final item = value[index];
          
          return WifiCard( item: item, onTap: () => onItemTap(item), security:  item.getSecurity(),);
        },
        separatorBuilder: (context, index) => SizedBox(height: 8),
        itemCount: value.length,
      ),
    );
  }
}
extension NetworkSecurityExt on WiFiAccessPoint {
  NetworkSecurity getSecurity() {
     final isWep = capabilities.contains("WEP");
    final isWpa = capabilities.contains("WPA");
return isWpa
                  ? NetworkSecurity.WPA
                  : isWep
                  ? NetworkSecurity.WEP
                  : NetworkSecurity.NONE;
  }
}