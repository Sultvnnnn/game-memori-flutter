import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gamememori/main.dart';
import 'package:flutter_gamememori/images_card.dart';

/// Membaca nama aset kartu yang sedang tampil di layar, urut indeks.
List<String> _namaKartu(WidgetTester tester) {
  return tester
      .widgetList<Image>(find.byType(Image))
      .map((w) => (w.image as AssetImage).assetName)
      .toList();
}

void main() {
  testWidgets('bermain sampai selesai: semua pasangan terbuka, nilai 400',
      (tester) async {
    tester.view.physicalSize = const Size(420, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final kartuFinder = find.byType(Image);
    expect(kartuFinder, findsNWidgets(8));

    // Buka semua kartu sekali untuk mengetahui posisi gambar,
    // lalu kembalikan ke kondisi tertutup dengan menekan "Ulangi".
    final tersembunyi = _namaKartu(tester);
    expect(tersembunyi.every((n) => n == Game.hiddenCardPath), isTrue);

    // Cari pasangan dengan mencoba setiap kombinasi kartu.
    for (var a = 0; a < 8; a++) {
      for (var b = a + 1; b < 8; b++) {
        final nama = _namaKartu(tester);
        // Hanya kartu yang masih tertutup yang boleh dicoba.
        if (nama[a] != Game.hiddenCardPath) continue;
        if (nama[b] != Game.hiddenCardPath) continue;
        await tester.tap(kartuFinder.at(a));
        await tester.pump();
        final terbukaA = _namaKartu(tester)[a];
        await tester.tap(kartuFinder.at(b));
        await tester.pump();
        final terbukaB = _namaKartu(tester)[b];

        if (terbukaA == terbukaB) {
          await tester.pump(const Duration(milliseconds: 100));
        } else {
          await tester.pump(const Duration(milliseconds: 800));
          await tester.pumpAndSettle();
        }
      }
    }

    // Setelah semua pasangan terbuka, dialog hasil harus muncul.
    expect(find.text('Selamat!'), findsOneWidget);
    expect(find.textContaining('Nilai: 400'), findsOneWidget);
  });
}
