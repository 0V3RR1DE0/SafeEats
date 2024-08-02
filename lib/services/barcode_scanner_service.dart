import 'package:camera/camera.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class BarcodeScannerService {
  late CameraController _cameraController;
  late BarcodeScanner _barcodeScanner;
  late TextRecognizer _textRecognizer;

  Future<void> initialize() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    await _cameraController.initialize();
    _barcodeScanner = BarcodeScanner();
    _textRecognizer = TextRecognizer();
  }

  Future<String?> scanBarcode() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }

    final image = await _cameraController.takePicture();
    final inputImage = InputImage.fromFilePath(image.path);
    
    // Try to scan barcode first
    final barcodes = await _barcodeScanner.processImage(inputImage);
    if (barcodes.isNotEmpty) {
      return barcodes.first.rawValue;
    }

    // If no barcode is found, try to extract numbers from the image
    final recognizedText = await _textRecognizer.processImage(inputImage);
    final String text = recognizedText.text;
    
    // Extract numbers from the recognized text
    final RegExp regex = RegExp(r'\d+');
    final Iterable<Match> matches = regex.allMatches(text);
    
    if (matches.isNotEmpty) {
      // Join all found numbers into a single string
      return matches.map((m) => m.group(0)).join();
    }

    // If no numbers are found, return null
    return null;
  }

  CameraController get cameraController => _cameraController;

  void dispose() {
    _cameraController.dispose();
    _barcodeScanner.close();
    _textRecognizer.close();
  }
}