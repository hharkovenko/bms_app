import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:bms_app/modules/provisioning/models/item.dart';

const searchMessage = [0xFF, 0x00, 0x01, 0x02];
const byteMaskTo255 = 0xff;
const receivePort = 26000;
const String deviceIp = "255.255.255.255";

class ProvisioningService {
  RawDatagramSocket? socket;
  bool isConnected = false;
    final StreamController<List<Item>> ssidListController = StreamController<List<Item>>.broadcast();
  final StreamController<List<int>> configResponseController = StreamController<List<int>>.broadcast();
  int devicePort = 49000;
  Future<void> init(int port) async {
    try {
      if (socket != null) {
        socket?.close();
      }
      devicePort = port;
      socket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4,
        receivePort,
      );
      socket?.broadcastEnabled = true;
      isConnected = true;
      startListening();
    } catch (e) {
      isConnected = false;
      rethrow;
    }
  }

  void sendMessage(List<int> data) {
    socket?.send(data, InternetAddress(deviceIp), devicePort);
  }

  void sendSearchMessage() {
    sendMessage(searchMessage);
  }


  void dispose() {
    socket?.close();
  }

  Future<void> startListening() async {
    socket?.listen((event) {
      if (event == RawSocketEvent.read) {
        Datagram? datagram = socket?.receive();
        if (datagram != null) {
          _decodeData(datagram.data);
        }
      }
    });
  }

  void _decodeData(Uint8List data) {
    if (data.isEmpty) return;
    if (data.length < 4) return;

    int commandType = data[3] & byteMaskTo255; // тип команди відповіді

    if (commandType == 129) {
      // Hex= 0x81 відповідь про мережу
      List<Item> ssidList = _decode81Data(data);
      if (ssidList.isNotEmpty) {
        Uint8List code2 = _generate02Data("lebed", "lebedhomewifi", 0);
        if (code2.isNotEmpty) {
          sendMessage(code2);
        }
        ssidListController.add(ssidList);
      }
      return;
    }

    if (commandType == 130) {
      // 0x82
      List<int> result = _decode82Data(data);
      configResponseController.add(result);

      if (result[0] == 0) {
        log("Not found this ssid");
        return;
      }

      if (result[1] == 0) {
        log("Password length incorrect");
      } else if (result[0] == 1 && result[1] == 1) {
        log(
          "Configuration has been completed, check the status of the module",
        );
      }
    }
  }

  static Uint8List _generate02Data(String ssid, String password, int mode) {
    try {
      String combined = "$ssid\r\n$password";
      List<int> bytes = utf8.encode(combined);

      Uint8List result = Uint8List(bytes.length + 2);
      result[0] = 2;
      result[1] = mode & 255;

      for (int i = 0; i < bytes.length; i++) {
        result[i + 2] = bytes[i];
      }

      return _generateCmd(result);
    } catch (e) {
      log('Error generating 02 data: $e');
      return Uint8List(0);
    }
  }

  static List<int> _decode82Data(Uint8List data) {
    if (data.length < 6) return [0, 0];
    return [data[4] & byteMaskTo255, data[5] & byteMaskTo255];
  }

  static List<Item> _decode81Data(Uint8List data) {
    List<Item> itemList = [];
    int length = data.length - 6;
    if (length <= 0) return itemList;

    Uint8List payload = data.sublist(5, 5 + length);

    int i = 0;
    int startIndex = 0;

    while (i < length - 1) {
      int nextIndex = i + 1;

      // Check for \r\n delimiter
      if (i + 1 < payload.length && payload[i] == 13 && payload[i + 1] == 10) {
        // \r\n


        int nameLength = (i - 2) - startIndex;
        String name = '';
        int dbm = 0;
        if (nameLength > 0 && startIndex + nameLength <= payload.length) {
          Uint8List nameBytes = payload.sublist(
            startIndex,
            startIndex + nameLength,
          );
          name = utf8.decode(nameBytes).trim();

          if (i - 1 >= 0 && i - 1 < payload.length) {
          dbm = (payload[i - 1] & byteMaskTo255);
          }

          itemList.add(Item(name: name, dbm: dbm));
        }

        startIndex = i + 2;
      }
      i = nextIndex;
    }

    return itemList;
  }

  static Uint8List _generateCmd(Uint8List data) {
    int length = data.length + 4;
    Uint8List result = Uint8List(length);

    result[0] = 0xFF; // -1 as unsigned byte

    Uint8List lengthBytes = _int2byte(data.length);
    result[1] = lengthBytes[1];
    result[2] = lengthBytes[0];

    int checksumIndex = length - 1;
    result[checksumIndex] = (result[1] + result[2]) & 0xFF;

    for (int i = 0; i < data.length; i++) {
      result[i + 3] = data[i];
      result[checksumIndex] = (result[checksumIndex] + data[i]) & 0xFF;
    }

    return result;
  }

  static Uint8List _int2byte(int value) {
    return Uint8List.fromList([
      value & 255,
      (value >> 8) & 255,
      (value >> 16) & 255,
      (value >>> 24) & 255,
    ]);
  }

}
