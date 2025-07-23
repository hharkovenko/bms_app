import 'dart:async';

import 'package:bms_app/modules/provisioning/models/wifi.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:plugin_wifi_connect/plugin_wifi_connect.dart';
import 'package:wifi_scan/wifi_scan.dart';

part 'wifi_list_provider.g.dart';

@riverpod
Future<List<WiFiAccessPoint>> wifiList(Ref ref) async {
  final can = await WiFiScan.instance.canStartScan(askPermissions: true);
  if (can != CanStartScan.yes) {
    throw Exception('Missing permissions to scan nearby wifi networks');
  }
  await WiFiScan.instance.startScan();
  final completer = Completer<List<WiFiAccessPoint>>();
  final subscription = WiFiScan.instance.onScannedResultsAvailable.listen((
    results,
  ) {
    if (!completer.isCompleted) completer.complete(results);
  });

  final results = await completer.future;
  subscription.cancel();
  final nonEmpty = results.where((e) => e.ssid.isNotEmpty).toList();
  
  return groupBy(
    nonEmpty,
    (WiFiAccessPoint wifi) => wifi.ssid,
  ).values.map((group) => group.first).toList();
}
