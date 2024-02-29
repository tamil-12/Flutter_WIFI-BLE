import 'dart:async';
import 'dart:convert'; // Import for utf8.encode
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import "../utils/snackbar.dart";
import "descriptor_tile.dart";

class CharacteristicTile extends StatefulWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;

  const CharacteristicTile({Key? key, required this.characteristic, required this.descriptorTiles}) : super(key: key);

  @override
  State<CharacteristicTile> createState() => _CharacteristicTileState();
}

class _CharacteristicTileState extends State<CharacteristicTile> {
  late StreamSubscription<List<int>> _lastValueSubscription;

  @override
  void initState() {
    super.initState();
    _lastValueSubscription = widget.characteristic.lastValueStream.listen((value) {
      // Handle incoming values if needed
    });
  }

  @override
  void dispose() {
    _lastValueSubscription.cancel();
    super.dispose();
  }

  Future<void> sendOn() async {
    try {
      String dataToSend = "on"; // Your string data to send
      List<int> bytes = utf8.encode(dataToSend); // Convert the string to UTF-8 bytes
      await widget.characteristic.write(bytes); // Write the bytes to the characteristic
      Snackbar.show(ABC.c, "Sent 'On' to Characteristic: Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Write 'On' Error:", e), success: false);
    }
  }

  Future<void> sendOff() async {
    try {
      String dataToSend = "off"; // Your string data to send
      List<int> bytes = utf8.encode(dataToSend); // Convert the string to UTF-8 bytes
      await widget.characteristic.write(bytes); // Write the bytes to the characteristic
      Snackbar.show(ABC.c, "Sent 'Off' to Characteristic: Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Write 'Off' Error:", e), success: false);
    }
  }

  Widget buildOnButton(BuildContext context) {
    return TextButton(
      child: Text("Send On"),
      onPressed: () async {
        await sendOn();
      },
    );
  }

  Widget buildOffButton(BuildContext context) {
    return TextButton(
      child: Text("Send Off"),
      onPressed: () async {
        await sendOff();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Characteristic'),
            Text('UUID: ${widget.characteristic.uuid}', style: TextStyle(fontSize: 13)),
          ],
        ),
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildOnButton(context),
            buildOffButton(context),
          ],
        ),
        contentPadding: const EdgeInsets.all(0.0),
      ),
      children: widget.descriptorTiles,
    );
  }
}
