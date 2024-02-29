import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_gauges/gauges.dart'; // Import Syncfusion Flutter package

class ConnectedPage extends StatefulWidget {
  final String deviceId;

  ConnectedPage({required this.deviceId});

  @override
  _ConnectedPageState createState() => _ConnectedPageState();
}

class _ConnectedPageState extends State<ConnectedPage> {
  late final FlutterReactiveBle _flutterReactiveBle;
  late QualifiedCharacteristic _characteristic;
  double _gaugeValue = 0; // Variable to hold gauge value
  List<String> _items = []; // List to hold selected options
  bool _isSwitchOn = false; // Variable to hold switch state

  @override
  void initState() {
    super.initState();
    _flutterReactiveBle = FlutterReactiveBle();
    _characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse("fc96f65e-318a-4001-84bd-77e9d12af44b"),
      characteristicId: Uuid.parse("04d3552e-b9b3-4be6-a8b4-aa43c4507c4d"),
      deviceId: widget.deviceId,
    );
    _subscribeToCharacteristic();
  }

  void _subscribeToCharacteristic() {
    _flutterReactiveBle.subscribeToCharacteristic(_characteristic).listen((data) {
      // Handle received data
      _handleReceivedData(data);
    }, onError: (error) {
      print('Error subscribing to characteristic: $error');
      // Handle subscription error
    });
  }

  void _handleReceivedData(List<int> data) {
    try {
      // Decode the received data
      String receivedString = utf8.decode(data);
      // Example: If the received data is a character string
      print('Received String: $receivedString');

      // Example: If the received data is a floating-point value
      double receivedValue = double.parse(receivedString);
      print('Received Value: $receivedValue');

      // Check if the widget is mounted before calling setState
      if (mounted) {
        setState(() {
          _gaugeValue = receivedValue;
        });
      }
    } catch (e) {
      print('Error handling received data: $e');
      // Handle parsing error
    }
  }

  void _sendData(String data) async {
    try {
      await _flutterReactiveBle.writeCharacteristicWithResponse(
        _characteristic,
        value: utf8.encode(data),
      );
      // Data sent successfully, provide feedback to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data sent successfully')),
      );
    } catch (e) {
      print('Error sending data: $e');
      // Handle write error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send data')),
      );
    }
  }

  void _showOptionsPopupMenu() {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.show_chart),
            title: Text('Radial Gauge'),
          ),
          value: 'Radial Gauge',
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.linear_scale),
            title: Text('Slider'),
          ),
          value: 'Slider',
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.text_fields),
            title: Text('Display'),
          ),
          value: 'Display',
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.toggle_on),
            title: Text('Switch'),
          ),
          value: 'Switch',
        ),
      ],
    ).then((value) {
      // Handle the selected option
      if (value != null) {
        setState(() {
          _items.add(value); // Add selected option to the list
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connected Device'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showOptionsPopupMenu,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Device ID: ${widget.deviceId}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(_items[index]),
                    onDismissed: (direction) {
                      setState(() {
                        _items.removeAt(index); // Remove item from the list
                      });
                    },
                    background: Container(color: Colors.red),
                    child: buildItem(_items[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(String item) {
    switch (item) {
      case 'Radial Gauge':
        return Container(
          height: 200,
          width: double.infinity,
          child: Card(
            elevation: 4,
            child: Center(
              child: SfRadialGauge(
                // Radial Gauge configuration
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: 100,
                    ranges: <GaugeRange>[
                      GaugeRange(startValue: 0, endValue: _gaugeValue, color: Colors.green),
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(value: _gaugeValue, enableAnimation: true),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Text(
                          _gaugeValue.toStringAsFixed(2),
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        angle: 90,
                        positionFactor: 0.5,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      case 'Slider':
        return Container(
          width: double.infinity,
          child: Column(
            children: [
              Slider(
                value: _gaugeValue,
                min: 0,
                max: 100,
                onChanged: (value) {
                  setState(() {
                    _gaugeValue = value;
                  });
                },
              ),
              Text(
                'Value: $_gaugeValue',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      case 'Display':
        return GestureDetector(
          onTap: () {
            // Handle displaying the value
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Value'),
                content: Text('$_gaugeValue'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              'Display',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        );
      case 'Switch':
        return Container(
          width: double.infinity,
          child: Column(
            children: [
              Switch(
                value: _isSwitchOn,
                onChanged: (value) {
                  setState(() {
                    _isSwitchOn = value;
                  });
                  // Send data based on switch value
                  String dataToSend = value ? '1' : '0';
                  _sendData(dataToSend);
                },
              ),
            ],
          ),
        );

      default:
        return SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
