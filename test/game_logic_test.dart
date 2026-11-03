import 'package:flutter_gamememori/images_card.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Game Memori - 8 kartu', () {
    late Game game;

    setUp(() {
      game = Game()..initGame();
    });

    test('jumlah kartu menjadi 8 (4 pasang gambar)', () {
      expect(game.cardCount, 8);
      expect(game.cardsList.length, 8);
      expect(game.gameImg.length, 8);
    });

    test('setiap gambar muncul tepat dua kali', () {
      final jumlah = <String, int>{};
      for (final gambar in game.cardsList) {
        jumlah[gambar] = (jumlah[gambar] ?? 0) + 1;
      }
      expect(jumlah.length, 4);
      expect(jumlah.values.every((n) => n == 2), isTrue);
    });

    test('semua kartu tertutup saat game dimulai', () {
      expect(
        game.gameImg.every((gambar) => gambar == Game.hiddenCardPath),
        isTrue,
      );
      expect(game.langkah, 0);
      expect(game.nilai, 0);
    });

    test('pasangan cocok menambah nilai dan menandai kartu', () {
      final target = game.cardsList[0];
      final pasangan = game.cardsList.lastIndexOf(target);

      game.buka(0);
      game.buka(pasangan);
      expect(game.periksa(), isTrue);
      expect(game.cocok(0), isTrue);
      expect(game.cocok(pasangan), isTrue);
      expect(game.nilai, Game.nilaiPerPasangan);
      expect(game.langkah, 2);
    });

    test('pasangan salah ditutup kembali tanpa menambah nilai', () {
      final a = game.cardsList[0];
      final b = game.cardsList.firstWhere((gambar) => gambar != a);

      game.buka(0);
      game.buka(game.cardsList.indexOf(b));
      expect(game.periksa(), isFalse);

      game.tutup();
      expect(
        game.gameImg.every((gambar) => gambar == Game.hiddenCardPath),
        isTrue,
      );
      expect(game.nilai, 0);
    });

    test('kartu yang sudah cocok tidak bisa dibuka lagi', () {
      final target = game.cardsList[0];
      final pasangan = game.cardsList.lastIndexOf(target);
      game.buka(0);
      game.buka(pasangan);
      game.periksa();

      expect(game.bisaDibuka(0), isFalse);
      expect(game.bisaDibuka(pasangan), isFalse);
    });

    test('game selesai setelah keempat pasangan terbuka', () {
      for (final gambar in Game.imageAssets) {
        final pertama = game.cardsList.indexOf(gambar);
        final kedua = game.cardsList.lastIndexOf(gambar);
        game.buka(pertama);
        game.buka(kedua);
        expect(game.periksa(), isTrue);
      }
      expect(game.selesai, isTrue);
      expect(game.nilai, Game.imageAssets.length * Game.nilaiPerPasangan);
    });
  });
}
