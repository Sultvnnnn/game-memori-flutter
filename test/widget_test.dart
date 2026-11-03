import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gamememori/main.dart';
import 'package:flutter_gamememori/images_card.dart';

void main() {
  testWidgets('HomeScreen menampilkan 8 kartu dan skor awal 0',
      (tester) async {
    tester.view.physicalSize = const Size(420, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Game Memori'), findsOneWidget);
    expect(find.text('Langkah'), findsOneWidget);
    expect(find.text('Nilai'), findsOneWidget);
    expect(find.text('0'), findsNWidgets(2));
    expect(find.byType(Image), findsNWidgets(8));
  });

  testWidgets('tap dua kartu yang salah menaikkan langkah', (tester) async {
    tester.view.physicalSize = const Size(420, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final kartu = find.byType(GestureDetector);
    await tester.tap(kartu.at(0));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);

    // Render golden setelah dua kartu dibuka untuk dokumentasi.
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/home_two_cards_open.png'),
    );
  });

  test('Game awal: 8 kartu tertutup, 4 gambar unik', () {
    final game = Game()..initGame();
    expect(game.cardCount, 8);
    expect(game.cardsList.toSet().length, Game.imageAssets.length);
  });
}
