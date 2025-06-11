import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scanit/main.dart';

void main() {
  testWidgets('Home page loads with correct UI elements', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Cek apakah app bar dengan judul ScanIT muncul
    expect(find.text('ScanIT'), findsOneWidget);

    // Cek apakah ilustrasi QR code (SVG) muncul
    expect(find.byType(Image), findsOneWidget); // Jika pakai Image.asset
    // atau jika pakai flutter_svg:
    // expect(find.byType(SvgPicture), findsOneWidget);

    // Cek apakah floating action button dengan ikon tambah muncul
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Navigasi ke halaman Scan saat FAB ditekan', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Tekan FAB
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle(); // Tunggu animasi selesai

    // Cek apakah halaman scan muncul (dengan judul "Scan QR")
    expect(find.text('Scan QR'), findsOneWidget);
    expect(find.byIcon(Icons.flip_camera_android), findsOneWidget); // Ikon switch kamera
  });

  testWidgets('Navigasi ke halaman Result setelah scan', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Pergi ke halaman scan
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Simulasikan hasil scan berhasil → manual routing karena kamera tidak aktif di test
    final BuildContext context = tester.element(find.byType(Scaffold).first);
    Navigator.of(context).pushNamed('/result', arguments: 'https://example.com');
    await tester.pumpAndSettle();

    // Periksa apakah halaman result muncul
    expect(find.text('Scan Result'), findsOneWidget);
    expect(find.textContaining('https://example.com'), findsOneWidget);
    expect(find.byIcon(Icons.save_alt), findsOneWidget); // Tombol simpan
  });
}
