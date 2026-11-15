import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/theme/portfolio_theme.dart';
import 'package:myportofolio_mobile/widgets/portfolio_sections.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  final String npm = '2506541723';
  final String nama = 'Muhammad Osman Fardin';
  final String kelas = 'PBP D';
  final List<ItemHomepage> items = const [
    ItemHomepage('Lihat Proyek', Icons.folder, PortfolioColors.navy),
    ItemHomepage('Tambah Proyek', Icons.add_circle, PortfolioColors.cloud),
    ItemHomepage('Logout', Icons.logout, PortfolioColors.copper),
  ];

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        titleSpacing: 20,
        title: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1056),
            child: SizedBox(
              width: double.infinity,
              child: Text(nama, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, viewport) {
          final padding = viewport.maxWidth >= 900 ? 32.0 : 20.0;
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(padding, 28, padding, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _ProfileCards(npm: npm, nama: nama, kelas: kelas),
                      const SizedBox(height: 32),
                      const PortfolioIntro(),
                      const SizedBox(height: 40),
                      Semantics(
                        header: true,
                        child: Text(
                          'Portfolio',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(height: 16),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final columns =
                              constraints.maxWidth >= 720 && textScale < 1.5
                              ? 3
                              : 1;
                          return GridView.count(
                            primary: false,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            crossAxisCount: columns,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 12,
                            mainAxisExtent:
                                (columns == 1 ? 88 : 160) * textScale,
                            children: items
                                .map(
                                  (item) =>
                                      ItemCard(item, horizontal: columns == 1),
                                )
                                .toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                      const PortfolioAbout(),
                      const SizedBox(height: 40),
                      const PortfolioFooter(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProfileCards extends StatelessWidget {
  const _ProfileCards({
    required this.npm,
    required this.nama,
    required this.kelas,
  });

  final String npm;
  final String nama;
  final String kelas;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
    return LayoutBuilder(
      builder: (context, constraints) {
        final nameCard = InfoCard(title: 'Name', content: nama);
        final npmCard = InfoCard(title: 'NPM', content: npm);
        final classCard = InfoCard(title: 'Class', content: kelas);
        if (constraints.maxWidth >= 600 && textScale < 1.5) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: npmCard),
              const SizedBox(width: 16),
              Expanded(child: nameCard),
              const SizedBox(width: 16),
              Expanded(child: classCard),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            nameCard,
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: npmCard),
                const SizedBox(width: 12),
                Expanded(child: classCard),
              ],
            ),
          ],
        );
      },
    );
  }
}

class ItemHomepage {
  const ItemHomepage(this.name, this.icon, this.color);

  final String name;
  final IconData icon;
  final Color color;

  /// Memilih teks hitam/putih dengan rasio kontras terbesar terhadap warna kartu.
  /// Perhitungan memakai luminansi relatif dan rumus kontras WCAG.
  Color get foregroundColor {
    final luminance = color.computeLuminance();
    final contrastWithBlack = (luminance + 0.05) / 0.05;
    final contrastWithWhite = 1.05 / (luminance + 0.05);
    return contrastWithBlack >= contrastWithWhite ? Colors.black : Colors.white;
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard(this.item, {this.horizontal = false, super.key});

  final ItemHomepage item;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = item.foregroundColor;
    const borderRadius = PortfolioTheme.radius;
    final label = Text(
      item.name,
      style: TextStyle(
        color: foregroundColor,
        fontFamily: PortfolioTheme.headingFont,
        fontWeight: FontWeight.w500,
        fontSize: 15,
        height: 1.3,
      ),
    );
    final icon = Icon(item.icon, color: foregroundColor, size: 28);

    return Semantics(
      button: true,
      child: Material(
        color: item.color,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: () {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  content: Text('Kamu telah menekan tombol ${item.name}!'),
                ),
              );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: horizontal
                ? Row(
                    children: [
                      icon,
                      const SizedBox(width: 16),
                      Expanded(child: label),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.arrow_outward,
                        size: 20,
                        color: foregroundColor,
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [icon, const SizedBox(height: 12), label],
                  ),
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: PortfolioColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: PortfolioTheme.radius,
        side: BorderSide(color: PortfolioColors.line),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: PortfolioColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                color: PortfolioColors.ink,
                fontSize: 16,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
