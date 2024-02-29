// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// import 'package:snowcounter/screens/connected_screen.dart';
// import 'package:snowcounter/wifi_list_page.dart'; // Import the WiFi list page
// import 'connected_screen.dart';
//
// const SERVICE_UUID = "fc96f65e-318a-4001-84bd-77e9d12af44b";
// const CHARACTERISTIC_UUID_RX = "04d3552e-b9b3-4be6-a8b4-aa43c4507c4d";
// const CHARACTERISTIC_UUID_TX = "94b43599-5ea2-41e7-9d99-6ff9b904ae3a";
//
// class BluetoothScanPage extends StatefulWidget {
//   @override
//   _BluetoothScanPageState createState() => _BluetoothScanPageState();
// }
//
// class _BluetoothScanPageState extends State<BluetoothScanPage> {
//   final flutterReactiveBle = FlutterReactiveBle();
//   List<DiscoveredDevice> discoveredDevices = [];
//   Map<String, bool> connectedDevices = {};
//
//   bool isScanning = false;
//   bool isDeviceConnected = false;
//   String deviceData = '';
//   StreamSubscription? scanSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   Future<void> scanForDevices() async {
//     setState(() {
//       isScanning = true;
//       discoveredDevices.clear(); // Clear existing devices before scanning
//     });
//
//     try {
//       scanSubscription =
//           flutterReactiveBle.scanForDevices(withServices: []).listen((device) {
//             setState(() {
//               if (!discoveredDevices.any((element) =>
//               element.id == device.id) && device.name != null) {
//                 discoveredDevices.add(device);
//                 connectedDevices[device.id] =
//                 false; // Initialize as not connected
//               }
//             });
//           }, onError: (dynamic error) {
//             print('Error during scanning: $error');
//             setState(() {
//               isScanning = false;
//             });
//           }, onDone: () {
//             setState(() {
//               isScanning = false;
//             });
//           });
//
//       // Stop scanning after 10 seconds
//       Timer(Duration(seconds: 10), () {
//         scanSubscription?.cancel();
//         setState(() {
//           isScanning = false;
//         });
//       });
//     } catch (e) {
//       print('Error during scanning: $e');
//       setState(() {
//         isScanning = false;
//       });
//     }
//   }
//
//   Future<void> connectToDevice(DiscoveredDevice device) async {
//     try {
//       await flutterReactiveBle
//           .connectToDevice(
//         id: device.id,
//         servicesWithCharacteristicsToDiscover: {},
//         connectionTimeout: const Duration(seconds: 2),
//       )
//           .first;
//       print('Connected to ${device.name}');
//       setState(() {
//         connectedDevices[device.id] = true; // Mark as connected
//         isDeviceConnected = true;
//       });
//
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) =>
//               ConnectedPage(
//                 deviceId: device.id,
//                 sendDataToDevice: sendDataToDevice,
//               ),
//         ),
//       );
//
//       // Subscribe to characteristic for receiving data
//       flutterReactiveBle.subscribeToCharacteristic(
//         QualifiedCharacteristic(
//           serviceId: Uuid.parse(SERVICE_UUID),
//           characteristicId: Uuid.parse(CHARACTERISTIC_UUID_TX),
//           deviceId: device.id,
//         ),
//       ).listen((data) {
//         setState(() {
//           deviceData = utf8.decode(data); // Convert received data to string
//         });
//       });
//     } catch (e) {
//       print('Error connecting to ${device.name}: $e');
//     }
//   }
//
//   Future<void> sendDataToDevice(String data) async {
//     try {
//       final encodedData = utf8.encode(data);
//       await flutterReactiveBle.writeCharacteristicWithResponse(
//         QualifiedCharacteristic(
//           serviceId: Uuid.parse(SERVICE_UUID),
//           characteristicId: Uuid.parse(CHARACTERISTIC_UUID_RX),
//           deviceId: discoveredDevices
//               .firstWhere((device) => connectedDevices[device.id] == true)
//               .id,
//         ),
//         value: encodedData,
//       );
//     } catch (e) {
//       print('Error sending data: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bluetooth Mode'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.bluetooth),
//             onPressed: () {
//               // Handle Bluetooth button press here
//               // You may want to navigate to another page or perform other actions
//               // For now, let's just print a message
//               print('Bluetooth button pressed');
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.wifi),
//             onPressed: () {
//               // Handle WiFi button press here
//               // Navigate to WiFi list page
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => WifiListPage()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: isScanning ? null : scanForDevices,
//             child: Text(isScanning ? 'Scanning...' : 'Scan for Devices'),
//           ),
//           SizedBox(height: 10),
//           Expanded(
//             child: ListView.builder(
//               itemCount: discoveredDevices.length,
//               itemBuilder: (context, index) {
//                 final device = discoveredDevices[index];
//                 if (device.name != null) {
//                   return ListTile(
//                     title: Text(device.name!),
//                     subtitle: Text(device.id),
//                     trailing: ElevatedButton(
//                       onPressed: connectedDevices[device.id] == true
//                           ? null
//                           : () => connectToDevice(device),
//                       child: Text(
//                         connectedDevices[device.id] == true
//                             ? 'Connected'
//                             : 'Connect',
//                       ),
//                     ),
//                   );
//                 } else {
//                   // Return an empty container if device name is null
//                   return Container();
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//

// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// import 'package:snowcounter/screens/connected_screen.dart';
// import 'package:snowcounter/wifi_list_page.dart'; // Import the WiFi list page
// import 'connected_screen.dart';
//
// const SERVICE_UUID = "fc96f65e-318a-4001-84bd-77e9d12af44b";
// const CHARACTERISTIC_UUID_RX = "04d3552e-b9b3-4be6-a8b4-aa43c4507c4d";
// const CHARACTERISTIC_UUID_TX = "94b43599-5ea2-41e7-9d99-6ff9b904ae3a";
//
// class BluetoothScanPage extends StatefulWidget {
//   @override
//   _BluetoothScanPageState createState() => _BluetoothScanPageState();
// }
//
// class _BluetoothScanPageState extends State<BluetoothScanPage> {
//   final flutterReactiveBle = FlutterReactiveBle();
//   List<DiscoveredDevice> discoveredDevices = [];
//   Map<String, bool> connectedDevices = {};
//
//   bool isScanning = false;
//   bool isDeviceConnected = false;
//   String deviceData = '';
//   StreamSubscription? scanSubscription;
//   StreamSubscription? characteristicSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     scanSubscription?.cancel();
//     characteristicSubscription?.cancel();
//     super.dispose();
//   }
//
//   Future<void> scanForDevices() async {
//     setState(() {
//       isScanning = true;
//       discoveredDevices.clear(); // Clear existing devices before scanning
//     });
//
//     try {
//       scanSubscription =
//           flutterReactiveBle.scanForDevices(withServices: []).listen((device) {
//             setState(() {
//               if (!discoveredDevices.any((element) =>
//               element.id == device.id) &&
//                   device.name != null) {
//                 discoveredDevices.add(device);
//                 connectedDevices[device.id] =
//                 false; // Initialize as not connected
//               }
//             });
//           }, onError: (dynamic error) {
//             print('Error during scanning: $error');
//             setState(() {
//               isScanning = false;
//             });
//           }, onDone: () {
//             setState(() {
//               isScanning = false;
//             });
//           });
//
//       // Stop scanning after 10 seconds
//       Timer(Duration(seconds: 10), () {
//         scanSubscription?.cancel();
//         setState(() {
//           isScanning = false;
//         });
//       });
//     } catch (e) {
//       print('Error during scanning: $e');
//       setState(() {
//         isScanning = false;
//       });
//     }
//   }
//
//   Future<void> connectToDevice(DiscoveredDevice device) async {
//     try {
//       await flutterReactiveBle
//           .connectToDevice(
//         id: device.id,
//         servicesWithCharacteristicsToDiscover: {},
//         connectionTimeout: const Duration(seconds: 2),
//       )
//           .first;
//       print('Connected to ${device.name}');
//       setState(() {
//         connectedDevices[device.id] = true; // Mark as connected
//         isDeviceConnected = true;
//       });
//
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ConnectedPage(
//             deviceId: device.id,
//             sendDataToDevice: sendDataToDevice,
//             deviceData: deviceData, // Pass the received data to ConnectedPage
//
//           ),
//         ),
//       );
//
//       // Subscribe to characteristic for receiving data
//       characteristicSubscription =
//           flutterReactiveBle.subscribeToCharacteristic(
//             QualifiedCharacteristic(
//               serviceId: Uuid.parse(SERVICE_UUID),
//               characteristicId: Uuid.parse(CHARACTERISTIC_UUID_RX),
//               deviceId: device.id,
//             ),
//           ).listen((data) {
//             setState(() {
//               deviceData = utf8.decode(data); // Convert received data to string
//             });
//           });
//     } catch (e) {
//       print('Error connecting to ${device.name}: $e');
//     }
//   }
//
//   Future<void> sendDataToDevice(String data) async {
//     try {
//       final encodedData = utf8.encode(data);
//       await flutterReactiveBle.writeCharacteristicWithResponse(
//         QualifiedCharacteristic(
//           serviceId: Uuid.parse(SERVICE_UUID),
//           characteristicId: Uuid.parse(CHARACTERISTIC_UUID_RX),
//           deviceId: discoveredDevices
//               .firstWhere((device) => connectedDevices[device.id] == true)
//               .id,
//         ),
//         value: encodedData,
//       );
//     } catch (e) {
//       print('Error sending data: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bluetooth Mode'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.bluetooth),
//             onPressed: () {
//               // Handle Bluetooth button press here
//               // You may want to navigate to another page or perform other actions
//               // For now, let's just print a message
//               print('Bluetooth button pressed');
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.wifi),
//             onPressed: () {
//               // Handle WiFi button press here
//               // Navigate to WiFi list page
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => WifiListPage()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: isScanning ? null : scanForDevices,
//             child: Text(isScanning ? 'Scanning...' : 'Scan for Devices'),
//           ),
//           SizedBox(height: 10),
//           Expanded(
//             child: ListView.builder(
//               itemCount: discoveredDevices.length,
//               itemBuilder: (context, index) {
//                 final device = discoveredDevices[index];
//                 if (device.name != null) {
//                   return ListTile(
//                     title: Text(device.name!),
//                     subtitle: Text(device.id),
//                     trailing: ElevatedButton(
//                       onPressed: connectedDevices[device.id] == true
//                           ? null
//                           : () => connectToDevice(device),
//                       child: Text(
//                         connectedDevices[device.id] == true
//                             ? 'Connected'
//                             : 'Connect',
//                       ),
//                     ),
//                   );
//                 } else {
//                   // Return an empty container if device name is null
//                   return Container();
//                 }
//               },
//             ),
//           ),
//           SizedBox(height: 10),
//           Text('Received Data: $deviceData'),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:snowcounter/screens/connected_screen.dart';

class BluetoothScanPage extends StatefulWidget {
  @override
  _BluetoothScanPageState createState() => _BluetoothScanPageState();
}

class _BluetoothScanPageState extends State<BluetoothScanPage> {
  final flutterReactiveBle = FlutterReactiveBle();
  List<DiscoveredDevice> discoveredDevices = [];
  Map<String, bool> connectedDevices = {};

  bool isScanning = false;

  StreamSubscription? scanSubscription;

  @override
  void dispose() {
    scanSubscription?.cancel();
    super.dispose();
  }

  Future<void> scanForDevices() async {
    setState(() {
      isScanning = true;
      discoveredDevices.clear(); // Clear existing devices before scanning
    });

    try {
      scanSubscription = flutterReactiveBle
          .scanForDevices(withServices: [])
          .listen((device) {
        setState(() {
          if (!discoveredDevices.any((element) => element.id == device.id) &&
              device.name != null) {
            discoveredDevices.add(device);
            connectedDevices[device.id] =
            false; // Initialize as not connected
          }
        });
      }, onError: (dynamic error) {
        print('Error during scanning: $error');
        setState(() {
          isScanning = false;
        });
      }, onDone: () {
        setState(() {
          isScanning = false;
        });
      });

      // Stop scanning after 6 seconds
      Timer(Duration(seconds: 6), () {
        if (isScanning) {
          scanSubscription?.cancel();
          setState(() {
            isScanning = false;
          });
        }
      });
    } catch (e) {
      print('Error during scanning: $e');
      setState(() {
        isScanning = false;
      });
    }
  }

  Future<void> connectToDevice(DiscoveredDevice device) async {
    try {
      await flutterReactiveBle
          .connectToDevice(
        id: device.id,
        servicesWithCharacteristicsToDiscover: {},
        connectionTimeout: const Duration(seconds: 2),
      )
          .first;
      print('Connected to ${device.name}');
      setState(() {
        connectedDevices[device.id] = true; // Mark as connected
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConnectedPage(
            deviceId: device.id,
          ),
        ),
      );
    } catch (e) {
      print('Error connecting to ${device.name}: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Mode'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: isScanning ? null : scanForDevices,
            child: Text(isScanning ? 'Scanning...' : 'Scan for Devices'),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: discoveredDevices.length,
              itemBuilder: (context, index) {
                final device = discoveredDevices[index];
                if (device.name != null) {
                  return ListTile(
                    title: Text(device.name!),
                    subtitle: Text(device.id),
                    trailing: ElevatedButton(
                      onPressed: connectedDevices[device.id] == true
                          ? null
                          : () => connectToDevice(device),
                      child: Text(
                        connectedDevices[device.id] == true
                            ? 'Connected'
                            : 'Connect',
                      ),
                    ),
                  );
                } else {
                  // Return an empty container if device name is null
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
