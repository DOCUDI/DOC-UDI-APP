import 'dart:io';

import 'package:docudi/provider/dataProvider.dart';
import 'package:docudi/upcoming_appointments_screen/start_successful_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CameraScreen extends StatefulWidget {
  static const routeName = "/scan";

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool pushed = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.resumeCamera();

    controller.scannedDataStream.listen((scanData) {
      print(scanData.code);
      if (scanData.code != null) Provider.of<DataProvider>(context, listen: false).scannedDoctorId = scanData.code!;
      if (!pushed) {
        if (Provider.of<DataProvider>(context, listen: false).scannedDoctorId != Provider.of<DataProvider>(context, listen: false).upcomingApptStart["doctorId"]) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect scanner QR Code!')),
          );
          Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
        } else {
          Navigator.of(context).pushReplacementNamed(StartSuccessfulScreen.routeName);
        }
      }

      pushed = true;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
