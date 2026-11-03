import 'package:flutter/material.dart';

import 'images_card.dart';
import 'info_card.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Memori',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFE55870),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Game _game = Game();

  /// Dikunci selama dua kartu salah sedang menunggu ditutup.
  bool _terkunci = false;
  bool _sudahSelesai = false;

  @override
  void initState() {
    super.initState();
    _game.initGame();
  }

  void _ulangi() {
    setState(() {
      _game.initGame();
      _terkunci = false;
      _sudahSelesai = false;
    });
  }

  Future<void> _ketuk(int index) async {
    if (_terkunci || !_game.bisaDibuka(index)) return;

    setState(() => _game.buka(index));

    if (!_game.sedangMenunggu) return;

    if (_game.periksa()) {
      setState(() {});
      if (_game.selesai && !_sudahSelesai) {
        _sudahSelesai = true;
        _tampilkanHasil();
      }
      return;
    }

    _terkunci = true;
    await Future.delayed(Game.jedaTutup);
    if (!mounted) return;
    setState(() => _game.tutup());
    _terkunci = false;
  }

  Future<void> _tampilkanHasil() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Selamat!'),
        content: Text(
          'Semua pasangan terbuka.\n\n'
          'Langkah: ${_game.langkah}\n'
          'Nilai: ${_game.nilai}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _ulangi();
            },
            child: const Text('Ulangi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE55870),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              const Text(
                'Game Memori',
                style: TextStyle(
                  fontSize: 34.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 12.0),
              Row(
                children: [
                  info_card('Langkah', '${_game.langkah}'),
                  info_card('Nilai', '${_game.nilai}'),
                ],
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Di layar lebar (desktop/tablet) pakai 4 kolom.
                    final kolom = constraints.maxWidth > 600 ? 4 : 2;
                    final baris = (_game.cardCount / kolom).ceil();
                    const jarak = 14.0;

                    // Ukuran kartu dihitung agar seluruh kartu pas di layar.
                    final lebar =
                        (constraints.maxWidth - jarak * (kolom - 1)) / kolom;
                    final tinggi =
                        (constraints.maxHeight - jarak * (baris - 1)) / baris;

                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _game.cardCount,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: kolom,
                        crossAxisSpacing: jarak,
                        mainAxisSpacing: jarak,
                        childAspectRatio: lebar / tinggi,
                      ),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) => _kartu(index),
                    );
                  },
                ),
              ),
              TextButton.icon(
                onPressed: _ulangi,
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  'Ulangi',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kartu(int index) {
    final sudahCocok = _game.matched[index];
    return GestureDetector(
      onTap: () => _ketuk(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: const Color(0xFFFFB46A),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: sudahCocok ? Colors.white : Colors.transparent,
            width: 3.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 6.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Image.asset(
            _game.gameImg[index],
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
