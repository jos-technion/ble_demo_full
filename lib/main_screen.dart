import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/ble_manager.dart';
import 'connection_screen.dart';

class MainScreen extends StatelessWidget {
  static final id = 'main_screen_id';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('BLE Demo'),
          leading: Provider.of<BLEManager>(context, listen: true).isConnected
              ? Icon(Icons.bluetooth_connected)
              : Icon(Icons.bluetooth_disabled)),
      body: Column(
        children: [
          FlatButton(
              onPressed: () {
                if (BLEManager.instance.isConnected) {
                  BLEManager.instance.disconnect();
                } else {
                  Navigator.pushNamed(context, ConnectionScreen.id);
                }
              },
              child: Provider.of<BLEManager>(context, listen: true).isConnected
                  ? Text('Disconnect')
                  : Text('Connect')),
          Padding(
            padding: const EdgeInsets.only(left: 100.0, right: 100),
            child: ListTile(
              title: Text('Sitting'),
              trailing: Text('12 steps'),
            ),
          ),
        ],
      ),
    );
  }
}
