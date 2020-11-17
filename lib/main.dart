import 'package:ble_demo/services/ble_manager.dart';
import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'connection_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  BLEManager manager = BLEManager.instance;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => manager,
        )
      ],
      child: MaterialApp(
        initialRoute: MainScreen.id,
        routes: {
          MainScreen.id: (context) => MainScreen(),
          ConnectionScreen.id: (context) => ConnectionScreen(),
        },
      ),
    );
  }
}
