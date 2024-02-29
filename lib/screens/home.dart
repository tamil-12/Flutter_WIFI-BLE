import 'package:flutter/material.dart';
import '../wifi_list_page.dart';
import 'scan_screen.dart';
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key); // Add const here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to BluetoothScanPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScanScreen()),
                );
              },
              icon: Icon(Icons.bluetooth), // Bluetooth icon
              label: Text('Bluetooth'),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to WifiListPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WifiListPage()),
                );
              },
              icon: Icon(Icons.wifi), // WiFi icon
              label: Text('Wi-Fi'),
            ),
          ],
        ),
      ),
    );
  }
}
