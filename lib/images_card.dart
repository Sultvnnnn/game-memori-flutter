/// Model dan aturan permainan Game Memori.
///
/// Tugas Sesi 3: kartu ditambah dari 4 menjadi 8 buah
/// (4 pasang gambar, masing-masing muncul dua kali).
class Game {
  /// 4 gambar berbeda x 2 kartu = 8 kartu.
  static const List<String> imageAssets = [
    'assets/images/circle.png',
    'assets/images/triangle.png',
    'assets/images/square.png',
    'assets/images/star.png',
  ];

  static const String hiddenCardPath = 'assets/images/hidden.png';

  /// Nilai tambah setiap pasangan yang berhasil dibuka.
  static const int nilaiPerPasangan = 100;

  /// Jarak waktu sebelum dua kartu yang salah ditutup kembali.
  static const Duration jedaTutup = Duration(milliseconds: 700);

  int get cardCount => imageAssets.length * 2;

  /// Susunan gambar sebenarnya (sudah diacak).
  late List<String> cardsList;

  /// Gambar yang sedang ditampilkan di layar.
  late List<String> gameImg;

  /// Kartu yang sudah berhasil dicocokkan.
  late List<bool> matched;

  int langkah = 0;
  int nilai = 0;

  /// Indeks kartu yang sedang terbuka (maksimal 2).
  final List<int> _terbuka = [];

  void initGame() {
    cardsList = [...imageAssets, ...imageAssets]..shuffle();
    gameImg = List<String>.filled(cardCount, hiddenCardPath);
    matched = List<bool>.filled(cardCount, false);
    _terbuka.clear();
    langkah = 0;
    nilai = 0;
  }

  bool get selesai => matched.every((cocok) => cocok);

  /// Apakah kartu pada [index] sudah berhasil dicocokkan.
  bool cocok(int index) => matched[index];

  bool get sedangMenunggu => _terbuka.length == 2;

  int get jumlahTerbuka => _terbuka.length;

  /// Kartu boleh dibuka bila belum cocok, belum terbuka, dan tidak ada
  /// dua kartu lain yang sedang menunggu.
  bool bisaDibuka(int index) =>
      !matched[index] && !_terbuka.contains(index) && _terbuka.length < 2;

  void buka(int index) {
    gameImg[index] = cardsList[index];
    _terbuka.add(index);
    langkah++;
  }

  /// Dipanggil setelah dua kartu terbuka.
  /// Mengembalikan true bila pasangannya cocok.
  bool periksa() {
    if (_terbuka.length < 2) return false;

    final pertama = _terbuka[0];
    final kedua = _terbuka[1];

    if (cardsList[pertama] == cardsList[kedua]) {
      matched[pertama] = true;
      matched[kedua] = true;
      nilai += nilaiPerPasangan;
      _terbuka.clear();
      return true;
    }
    return false;
  }

  /// Menutup kembali kartu yang tidak cocok.
  void tutup() {
    for (final index in _terbuka) {
      if (!matched[index]) gameImg[index] = hiddenCardPath;
    }
    _terbuka.clear();
  }
}
