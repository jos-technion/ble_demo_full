import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BLEManager with ChangeNotifier {
  bool _isConnected = false;
  FlutterBlue _flutterBlue = FlutterBlue.instance;
  BluetoothDevice connectedPeripheral;
  static final _instance = BLEManager._internal();

  BLEManager._internal() {
    //init();
  }
  void startScan(callback) {
    _flutterBlue.startScan(timeout: Duration(seconds: 10));

    _flutterBlue.scanResults.listen((results) {
      // do something with scan results

      for (ScanResult r in results) {
        callback(r.device);
        print('${r.device.name} found! rssi: ${r.rssi}');
      }
    });
  }

  void stopScan() {
    _flutterBlue.stopScan();
  }

  void connect(BluetoothDevice peripheral) async {
    connectedPeripheral = peripheral;

    print('connection to: ${peripheral.name}');
    // manager.stopScan();
    peripheral.state.listen((event) {
      switch (event) {
        case BluetoothDeviceState.connected:
          print('connected!');
          _isConnected = true;
          notifyListeners();
          startDiscovery();
          break;
        case BluetoothDeviceState.connecting:
          print('connecting');
          break;
        case BluetoothDeviceState.disconnected:
          _isConnected = false;
          notifyListeners();

          break;
      }
      print(event);
    });
    await peripheral.connect();
  }

  void startDiscovery() async {
    List<BluetoothService> services =
        await connectedPeripheral.discoverServices();
    /*services.forEach((service) {
      print(
          'service: ${service.uuid.toString()} ${service.uuid.toString() == "ced5fdb4-e645-0bb4-7a43-cabdf3197a77"}');
      if (service.uuid.toString() == "48ddf118-efd0-48fc-8f44-b9b8e17be397") {
        // CONFIG SERVICE
        // "6401a620-89c5-4135-b4af-ea1c2e1ce524" // control point
        // "38278651-76d7-4dee-83d8-894f3fa6bb99" // keep alive

        List<BluetoothCharacteristic> chars = service.characteristics;
        chars.forEach((char) async {
          if (char.uuid.toString() == "6401a620-89c5-4135-b4af-ea1c2e1ce524") {
            print('found control point!');
            _controlPoint = char;

            //List<int> value = await char.read();
            //print(value);
          }
          if (char.uuid.toString() == "38278651-76d7-4dee-83d8-894f3fa6bb99") {
            print('found keep alive');
            _keepAlive = char;
          }
        });
      }
      if (service.uuid.toString() == "544701c6-d711-11e4-b9d6-1681e6b88ec1") {
        print("found service");
        List<BluetoothCharacteristic> chars = service.characteristics;
        chars.forEach((char) async {
          print(char.uuid.toString());
          if (char.uuid.toString() == "544707d8-d711-11e4-b9d6-1681e6b88ec1") {
            // request char
            _requestChar = char;
          }
          if (char.uuid.toString() == "544706d7-d711-11e4-b9d6-1681e6b88ec1") {
            print('found char!');
            _imuChar = char;
          }
        });
      }
      // do something with service
    }
    );
*/
  }

  void disconnect() {
    _isConnected = false;
    connectedPeripheral.disconnect();
  }

  static get instance => _instance;
  bool get isConnected => _isConnected;
}
