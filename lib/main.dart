import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants.dart';
import 'pages/translate/translate_page.dart';
import 'services/sanity_service.dart';

String _formatDate(String? date) {
  if (date == null) return '';
  final parsed = DateTime.tryParse(date);
  if (parsed == null) return '';
  return DateFormat('dd-MM-yyyy').format(parsed);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Teman Isyarat',
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: C.bgLight,
        colorScheme: ColorScheme.fromSeed(
          seedColor: C.primary,
          primary: C.primary,
        ),
      ),
      home: const MainPage(),
    );
  }
}

class IsyaratItem {
  final int number;
  final String kode;
  final String label;
  final Color placeholderColor;

  const IsyaratItem({
    required this.number,
    required this.kode,
    required this.label,
    required this.placeholderColor,
  });
}

const List<IsyaratItem> isyaratList = [
  IsyaratItem(
    number: 1,
    kode: 'Aku',
    label: 'Aku',
    placeholderColor: Color(0xFF9E9E9E),
  ),
  IsyaratItem(
    number: 2,
    kode: 'Kamu',
    label: 'Kamu',
    placeholderColor: Color(0xFF9E9E9E),
  ),
  IsyaratItem(
    number: 3,
    kode: 'Dia',
    label: 'Dia',
    placeholderColor: Color(0xFF9E9E9E),
  ),
  IsyaratItem(
    number: 4,
    kode: 'Salam',
    label: 'Salam',
    placeholderColor: Color(0xFF9E9E9E),
  ),
  IsyaratItem(
    number: 5,
    kode: 'Terima Kasih',
    label: 'Terima Kasih',
    placeholderColor: Color(0xFF9E9E9E),
  ),
  IsyaratItem(
    number: 6,
    kode: 'Maaf',
    label: 'Maaf',
    placeholderColor: Color(0xFF9E9E9E),
  ),
  IsyaratItem(
    number: 7,
    kode: 'Nama',
    label: 'Nama',
    placeholderColor: Color(0xFF9E9E9E),
  ),
  IsyaratItem(
    number: 8,
    kode: 'Hari Ini',
    label: 'Hari Ini',
    placeholderColor: Color(0xFF9E9E9E),
  ),
  IsyaratItem(
    number: 9,
    kode: 'Besok',
    label: 'Besok',
    placeholderColor: Color(0xFF9E9E9E),
  ),
  IsyaratItem(
    number: 10,
    kode: 'Merah',
    label: 'Merah',
    placeholderColor: Color(0xFF9E9E9E),
  ),
  IsyaratItem(
    number: 11,
    kode: 'Kuning',
    label: 'Kuning',
    placeholderColor: Color(0xFF9E9E9E),
  ),
  IsyaratItem(
    number: 12,
    kode: 'Ayah',
    label: 'Ayah',
    placeholderColor: Color(0xFF9E9E9E),
  ),
  IsyaratItem(
    number: 13,
    kode: 'Ibu',
    label: 'Ibu',
    placeholderColor: Color(0xFF9E9E9E),
  ),
  IsyaratItem(
    number: 14,
    kode: 'Satu',
    label: 'Satu',
    placeholderColor: Color(0xFF9E9E9E),
  ),
  IsyaratItem(
    number: 15,
    kode: 'Dua',
    label: 'Dua',
    placeholderColor: Color(0xFF9E9E9E),
  ),
  IsyaratItem(
    number: 16,
    kode: 'Tiga',
    label: 'Tiga',
    placeholderColor: Color(0xFF9E9E9E),
  ),
  IsyaratItem(
    number: 17,
    kode: 'Teman',
    label: 'Teman',
    placeholderColor: Color(0xFF9E9E9E),
  ),
  IsyaratItem(
    number: 18,
    kode: 'Buku',
    label: 'Buku',
    placeholderColor: Color(0xFF9E9E9E),
  ),
  IsyaratItem(
    number: 19,
    kode: 'Apel',
    label: 'Apel',
    placeholderColor: Color(0xFF9E9E9E),
  ),
  IsyaratItem(
    number: 20,
    kode: 'Pisang',
    label: 'Pisang',
    placeholderColor: Color(0xFF9E9E9E),
  ),
];

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  void switchTab(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onSwitchTab: switchTab),
      const BelajarPage(),
      const ArtikelListPage(),
    ];

    return Scaffold(
      backgroundColor: C.bgLight,
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: _BottomNav(currentIndex: _index, onTap: switchTab),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: C.bg,
        border: Border(top: BorderSide(color: C.divider, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _navItem(0, Icons.home_outlined, Icons.home, 'Home'),
              _navItem(
                1,
                Icons.video_camera_front_outlined,
                Icons.video_camera_front,
                'Belajar',
              ),
              _navItem(2, Icons.article_outlined, Icons.article, 'Artikel'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData iconFilled, String label) {
    final sel = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 32,
              decoration: BoxDecoration(
                color: sel ? C.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  sel ? iconFilled : icon,
                  size: 22,
                  color: sel ? C.onPrimary : C.navInactive,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                color: sel ? C.text : C.navInactive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final Function(int) onSwitchTab;

  const HomePage({super.key, required this.onSwitchTab});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<SanityArticle>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = SanityService.getArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bgLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: C.bgLight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  SvgPicture.asset('assets/logo_s.svg', width: 32, height: 32),
                  const SizedBox(width: 8),
                  const Text(
                    'Teman Isyarat',
                    style: TextStyle(
                      color: C.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    ),
                    child: const Icon(Icons.menu, color: C.text, size: 26),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    _HeroCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TranslatePage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => widget.onSwitchTab(2),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Artikel',
                              style: TextStyle(
                                color: C.primary,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward,
                              color: C.primary,
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 2, 16, 10),
                      child: Text(
                        'Klik untuk lihat lebih banyak.',
                        style: TextStyle(
                          fontSize: 14,
                          color: C.text,
                          height: 1.4,
                        ),
                      ),
                    ),
                    FutureBuilder<List<SanityArticle>>(
                      future: _articlesFuture,
                      builder: (context, snapshot) {
                        final articles = snapshot.data ?? [];
                        if (articles.isEmpty) return const SizedBox.shrink();
                        return Column(
                          children: articles
                              .take(3)
                              .map(
                                (a) => _ArtikelItem(
                                  artikel: a,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          DetailArtikelPage(artikel: a),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final VoidCallback onTap;

  const _HeroCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 190,
        decoration: BoxDecoration(
          color: C.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 16,
              left: 16,
              child: SvgPicture.asset(
                'assets/hand_camera.svg',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),

            Positioned(
              bottom: 20,
              right: 20,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Terjemahkan',
                    style: TextStyle(
                      color: C.onPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: C.onPrimary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: C.onPrimary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArtikelItem extends StatelessWidget {
  final SanityArticle artikel;
  final VoidCallback onTap;

  const _ArtikelItem({required this.artikel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 100,
                height: 100,
                child: artikel.imageUrl != null
                    ? Image.network(
                        artikel.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _articlePlaceholder(),
                        loadingBuilder: (_, child, progress) =>
                            progress == null ? child : _articlePlaceholder(),
                      )
                    : _articlePlaceholder(),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      artikel.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: C.text,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      artikel.excerpt,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: C.textSub,
                        fontSize: 12,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${_formatDate(artikel.date)} • ${artikel.readingTime ?? 3} min read',
                      style: const TextStyle(color: C.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _articlePlaceholder() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: C.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SvgPicture.asset('assets/illust_m.svg', width: 80, height: 80),
        ),
      ),
    );
  }
}

class BelajarPage extends StatefulWidget {
  const BelajarPage({super.key});

  @override
  State<BelajarPage> createState() => _BelajarPageState();
}

class _BelajarPageState extends State<BelajarPage> {
  String _query = '';

  List<IsyaratItem> get filtered => isyaratList
      .where(
        (e) =>
            e.label.toLowerCase().contains(_query.toLowerCase()) ||
            e.kode.toLowerCase().contains(_query.toLowerCase()),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: C.bgLight,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: C.bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: C.divider),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Icons.search, color: C.textMuted, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => _query = v),
                        style: const TextStyle(fontSize: 15, color: C.text),
                        decoration: const InputDecoration(
                          hintText: 'Cari kata',
                          hintStyle: TextStyle(
                            color: C.textMuted,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.search, color: C.textMuted, size: 18),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.78,
                ),
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final item = filtered[i];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailIsyaratPage(isyarat: item),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFBDBDBD),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.sign_language,
                                color: Color(0xFF757575),
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item.number} - ${item.label}',
                                style: const TextStyle(
                                  color: C.text,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailIsyaratPage extends StatelessWidget {
  final IsyaratItem isyarat;

  const DetailIsyaratPage({super.key, required this.isyarat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: C.text, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFBDBDBD),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.sign_language,
                          color: Color(0xFF757575),
                          size: 100,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isyarat.label,
                          style: const TextStyle(
                            color: C.text,
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '#${isyarat.number} - ${isyarat.kode}',
                          style: const TextStyle(
                            color: C.textMuted,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArtikelListPage extends StatefulWidget {
  const ArtikelListPage({super.key});

  @override
  State<ArtikelListPage> createState() => _ArtikelListPageState();
}

class _ArtikelListPageState extends State<ArtikelListPage> {
  late Future<List<SanityArticle>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = SanityService.getArticles(limit: 12);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bgLight,
      body: SafeArea(
        child: FutureBuilder<List<SanityArticle>>(
          future: _articlesFuture,
          builder: (context, snapshot) {
            final articles = snapshot.data ?? [];
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              itemCount: articles.length,
              itemBuilder: (_, i) => _ArtikelItem(
                artikel: articles[i],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailArtikelPage(artikel: articles[i]),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DetailArtikelPage extends StatelessWidget {
  final SanityArticle artikel;

  const DetailArtikelPage({super.key, required this.artikel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: C.text, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: artikel.imageUrl != null
                            ? Image.network(
                                artikel.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => _detailPlaceholder(),
                                loadingBuilder: (_, child, progress) =>
                                    progress == null
                                    ? child
                                    : _detailPlaceholder(),
                              )
                            : _detailPlaceholder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      artikel.title,
                      style: const TextStyle(
                        color: C.text,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      '${_formatDate(artikel.date)} • ${artikel.readingTime ?? 3} min read',
                      style: const TextStyle(
                        color: C.primaryLink,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      artikel.bodyAsText,
                      style: const TextStyle(
                        color: C.text,
                        fontSize: 15,
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailPlaceholder() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: C.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SvgPicture.asset(
            'assets/illust_m.svg',
            width: 160,
            height: 160,
          ),
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            color: C.text,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: C.bg,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: C.text, size: 26),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: ListView(
        children: const [
          _SettingTile(
            icon: Icons.privacy_tip_outlined,
            label: 'Kebijakan Privasi',
            url:
                'https://www.termsfeed.com/live/5447ad9a-3da9-426c-be49-30e8c70bb2f1',
          ),
          _SettingTile(
            icon: Icons.storage_outlined,
            label: 'Akses ke Dataset',
            url: 'https://github.com/temanisyarat/dataset',
          ),
          _SettingTile(
            icon: Icons.star_border,
            label: 'Beri Rating',
            url:
                'https://play.google.com/store/apps/details?id=com.hibah.temanisyarat',
          ),
          _SettingTile(
            icon: Icons.language,
            label: 'Website',
            url: 'https://temanisyarat.com',
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;

  const _SettingTile({
    required this.icon,
    required this.label,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: C.text, size: 24),
      title: Text(
        label,
        style: const TextStyle(
          color: C.text,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      onTap: () => launchUrl(Uri.parse(url)),
    );
  }
}
