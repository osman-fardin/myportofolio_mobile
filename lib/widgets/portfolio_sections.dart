import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/theme/portfolio_theme.dart';

class PortfolioIntro extends StatelessWidget {
  const PortfolioIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: PortfolioTheme.radius,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: Image.asset(
                'assets/images/server-racks.webp',
                fit: BoxFit.cover,
                excludeFromSemantics: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Computer Science · Universitas Indonesia',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: PortfolioColors.cloud,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 16),
                Semantics(
                  header: true,
                  child: Text(
                    "Hi, I'm Fardin.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 590),
                    child: Text(
                      'Computer science student at Universitas Indonesia, '
                      'teaching assistant, and curious builder.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(color: PortfolioColors.muted),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PortfolioAbout extends StatelessWidget {
  const PortfolioAbout({super.key});

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;

    return ClipRRect(
      borderRadius: PortfolioTheme.radius,
      child: ColoredBox(
        color: PortfolioColors.navy,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.18,
                child: Image.asset(
                  'assets/images/about-cloudscape.jpg',
                  fit: BoxFit.cover,
                  excludeFromSemantics: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontal =
                      constraints.maxWidth >= 680 && textScale < 1.5;
                  final portrait = Container(
                    width: horizontal ? 160 : 128,
                    padding: const EdgeInsets.only(right: 6, bottom: 6),
                    decoration: const BoxDecoration(
                      color: PortfolioColors.copper,
                      borderRadius: PortfolioTheme.radius,
                    ),
                    child: ClipRRect(
                      borderRadius: PortfolioTheme.radius,
                      child: AspectRatio(
                        aspectRatio: 4 / 5,
                        child: Image.asset(
                          'assets/images/Fardin.JPG',
                          fit: BoxFit.cover,
                          alignment: const Alignment(0, -0.04),
                          semanticLabel: 'Foto Muhammad Osman Fardin',
                          cacheWidth: 480,
                        ),
                      ),
                    ),
                  );
                  final copy = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        header: true,
                        child: Text(
                          'About me',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'CS student at Universitas Indonesia exploring the cloudy '
                        'side of security, while helping guide new programmers '
                        'through Programming Foundations 1. Equal parts builder, '
                        'debugger, and “wait, let’s trace the code one more time” person.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'S1 Ilmu Komputer · Universitas Indonesia',
                        style: TextStyle(
                          color: PortfolioColors.cloudSoft,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  );

                  if (horizontal) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        portrait,
                        const SizedBox(width: 32),
                        Expanded(child: copy),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [portrait, const SizedBox(height: 24), copy],
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

class PortfolioFooter extends StatelessWidget {
  const PortfolioFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: PortfolioColors.line)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Text(
          '© 2026 Muhammad Osman Fardin.\n'
          'Fakultas Ilmu Komputer, Universitas Indonesia.',
          style: TextStyle(
            color: PortfolioColors.muted,
            fontSize: 12,
            height: 1.6,
          ),
        ),
      ),
    );
  }
}
