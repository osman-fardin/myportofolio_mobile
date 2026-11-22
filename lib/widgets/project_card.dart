import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/theme/portfolio_theme.dart';

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
            if (item.name == 'Tambah Proyek') {
              Navigator.push<void>(
                context,
                MaterialPageRoute(builder: (_) => const ProjectFormPage()),
              );
            } else if (item.name == 'Tambah Pengalaman') {
              Navigator.push<void>(
                context,
                MaterialPageRoute(builder: (_) => const ExperienceFormPage()),
              );
            }
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
