import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'scan.dart';
import 'colors.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('ScanIT', style: TextStyle(color: AppColors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Opacity(
          opacity: 0.6,
          child: SvgPicture.asset(
            'assets/qr_illustration.svg',
            width: 200,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.orange,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ScanPage()),
        ),
      ),
    );
  }
}
