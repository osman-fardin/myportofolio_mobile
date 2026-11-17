import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/theme/portfolio_theme.dart';

enum PortfolioDestination { home, addProject }

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({required this.destination, super.key});

  final PortfolioDestination destination;

  void _navigate(BuildContext context, PortfolioDestination target) {
    final navigator = Navigator.of(context);
    Scaffold.of(context).closeDrawer();
    if (target == destination) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    navigator.pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => target == PortfolioDestination.home
            ? const MyHomePage()
            : const ProjectFormPage(),
      ),
    );
  }

  Widget _destinationTile(
    BuildContext context,
    PortfolioDestination target,
    String label,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: destination == target,
      selectedColor: PortfolioColors.navy,
      selectedTileColor: PortfolioColors.cloudSoft,
      minVerticalPadding: 16,
      onTap: () => _navigate(context, target),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: PortfolioColors.surface,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Tinggi mengikuti isi agar identitas tetap terbaca saat teks diperbesar.
            ColoredBox(
              color: PortfolioColors.navy,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        'MyPortfolio',
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(color: PortfolioColors.surface),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Muhammad Osman Fardin',
                      style: TextStyle(color: PortfolioColors.surface),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '2506541723 · PBP D',
                      style: TextStyle(color: PortfolioColors.surface),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            _destinationTile(
              context,
              PortfolioDestination.home,
              'Home',
              Icons.home_outlined,
            ),
            _destinationTile(
              context,
              PortfolioDestination.addProject,
              'Tambah Proyek',
              Icons.add_circle_outline,
            ),
          ],
        ),
      ),
    );
  }
}
