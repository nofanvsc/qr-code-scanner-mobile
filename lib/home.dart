import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'scan.dart';

class AppColors {
  static const Color white = Color(0xFFF3F3F3); // 60%
  static const Color black = Color(0xFF000000); // 30%
  static const Color orange = Color(0xFFFD6615); // 10%
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Header Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'ScanIT',
                  
                  style: TextStyle(
                    
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            // Illustration Center
            Center(
              child: Opacity(
                opacity: 0.5,
                child: SvgPicture.asset(
                  'assets/qr_illustration.svg',
                  width: 220,
                ),
              ),
            ),

            // FAB button styled
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ScanPage()),
                    );
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner_rounded,
                      color: AppColors.white,
                      size: 38,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
