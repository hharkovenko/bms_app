import 'package:bms_app/modules/home/home_widget.dart';
import 'package:bms_app/modules/provisioning/view/provisioning_settings_screen.dart';
import 'package:bms_app/modules/provisioning/view/wifi_list_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'router.g.dart'; 
@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    debugLogDiagnostics: true,
    routes: [
      GoRoute(path: '/', builder: (context, state) => HomeWidget()),

      GoRoute(
        path: '/provisioning',
        builder: (context, state) => WifiListScreen(),
        routes: [
          GoRoute(
            path: 'settings',
            builder: (context, state) => ProvisioningSettingsScreen(),
          ),
          GoRoute(
            path: 'wifiList',
            builder: (context, state) => WifiListScreen(),
          ),
        ],
      ),
    ],
  );
}
