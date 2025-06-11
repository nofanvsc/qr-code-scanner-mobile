import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'result.dart';
import 'colors.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final MobileScannerController controller = MobileScannerController();
  bool isFrontCamera = false;
  bool isScanned = false;

  void _switchCamera() {
    controller.switchCamera();
    setState(() {
      isFrontCamera = !isFrontCamera;
    });
  }

  void _onDetect(BarcodeCapture capture) {
    if (isScanned) return;
    final Barcode? barcode = capture.barcodes.first;
    final String? code = barcode?.rawValue;

    if (code != null) {
      setState(() => isScanned = true);
      controller.stop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(result: code),
        ),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: BackButton(color: AppColors.black),
        title: const Text('Scan QR', style: TextStyle(color: AppColors.black)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: _onDetect,
            overlay: ScannerOverlay(
              borderColor: AppColors.orange,
              borderWidth: 5,
              borderLength: 20,
              borderRadius: 10,
              cutOutSize: MediaQuery.of(context).size.width * 0.7,
            ),
          ),
          Positioned(
            bottom: 40,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: IconButton(
              icon: const Icon(Icons.cameraswitch, size: 50, color: AppColors.orange),
              onPressed: _switchCamera,
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlay extends StatelessWidget {
  final Color borderColor;
  final double borderWidth;
  final double borderLength;
  final double borderRadius;
  final double cutOutSize;

  const ScannerOverlay({
    required this.borderColor,
    required this.borderWidth,
    required this.borderLength,
    required this.borderRadius,
    required this.cutOutSize,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: QROverlayPainter(
        borderColor: borderColor,
        borderWidth: borderWidth,
        borderLength: borderLength,
        borderRadius: borderRadius,
        cutOutSize: cutOutSize,
      ),
      child: Container(),
    );
  }
}

class QROverlayPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;
  final double borderLength;
  final double borderRadius;
  final double cutOutSize;

  QROverlayPainter({
    required this.borderColor,
    required this.borderWidth,
    required this.borderLength,
    required this.borderRadius,
    required this.cutOutSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    final double width = cutOutSize;
    final double height = cutOutSize;
    final double left = (size.width - width) / 2;
    final double top = (size.height - height) / 2;

    final RRect rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, width, height),
      Radius.circular(borderRadius),
    );

    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
