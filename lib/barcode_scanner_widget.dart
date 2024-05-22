import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'product_info_page.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

class BarcodeScannerWidget extends StatefulWidget {
  @override
  _BarcodeScannerWidgetState createState() => _BarcodeScannerWidgetState();
}

class _BarcodeScannerWidgetState extends State<BarcodeScannerWidget> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
        controller!.pauseCamera();
        controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform != TargetPlatform.android && defaultTargetPlatform != TargetPlatform.iOS) {
      return Center(child: Text('QR Code Scanner not supported on this platform'));
    }

    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: (result != null)
                ? Text('Barcode Type: ${result!.format}   Data: ${result!.code}')
                : Text('Scan a code'),
          ),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        // Navigate to ProductInfoPage with the scanned data
        Navigator.push(
         context,
          MaterialPageRoute(
            builder: (context) => ProductInfoPage(product: {'code': result!.code}),
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
