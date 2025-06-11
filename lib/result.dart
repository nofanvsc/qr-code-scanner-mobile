import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart'; // GANTI DI SINI
import 'package:path_provider/path_provider.dart';
import 'colors.dart';

class ResultPage extends StatefulWidget {
  final String result;
  ResultPage({required this.result});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final ScreenshotController screenshotController = ScreenshotController();
  String status = "";

  Future<void> _saveQRImage() async {
    try {
      final Uint8List? image = await screenshotController.capture();

      if (image == null) {
        setState(() {
          status = 'Gagal mengambil screenshot.';
        });
        return;
      }

      final permission = await Permission.storage.request();
      if (!permission.isGranted) {
        setState(() {
          status = 'Permission ditolak.';
        });
        return;
      }

      final result = await ImageGallerySaverPlus.saveImage(
        image,
        quality: 100,
        name: 'screenshot_${DateTime.now().millisecondsSinceEpoch}',
      );

      final isSuccess = result['isSuccess'] == true;

      setState(() {
        status = isSuccess
            ? 'QR code berhasil disimpan ke galeri!'
            : 'Gagal menyimpan QR code.';
      });
    } catch (e) {
      setState(() {
        status = 'Terjadi error saat menyimpan: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: BackButton(color: AppColors.black),
        title: const Text('Scan Result', style: TextStyle(color: AppColors.black)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Screenshot(
              controller: screenshotController,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.orange),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: SelectableText(
                  widget.result,
                  style: const TextStyle(fontSize: 20, color: AppColors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              icon: const Icon(Icons.save_alt),
              label: const Text("Simpan ke Galeri", style: TextStyle(color: Colors.white)),
              onPressed: _saveQRImage,
            ),
            if (status.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(status, style: const TextStyle(color: AppColors.black)),
            ],
          ],
        ),
      ),
    );
  }
}
