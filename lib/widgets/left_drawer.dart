import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/theme/portfolio_theme.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';

enum PortfolioDestination { home, projects, addProject, addExperience }

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({required this.destination, super.key});

  final PortfolioDestination destination;

  Future<void> _navigate(
    BuildContext context,
    PortfolioDestination target,
  ) async {
    final navigator = Navigator.of(context);
    Scaffold.of(context).closeDrawer();
    if (target == destination) return;

    if (target == PortfolioDestination.addProject &&
        !await ensureLoggedIn(context)) {
      return;
    }
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    navigator.pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => switch (target) {
          PortfolioDestination.home => const MyHomePage(),
          PortfolioDestination.projects => const ProjectListScreen(),
          PortfolioDestination.addProject => const ProjectFormPage(),
          PortfolioDestination.addExperience => const ExperienceFormPage(),
        },
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
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;
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
              PortfolioDestination.projects,
              'Lihat Proyek',
              Icons.folder_outlined,
            ),
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
            _destinationTile(
              context,
              PortfolioDestination.addExperience,
              'Tambah Pengalaman',
              Icons.work_outline,
            ),
            ListTile(
              leading: Icon(isLoggedIn ? Icons.logout : Icons.login),
              title: Text(isLoggedIn ? 'Logout' : 'Login'),
              onTap: () async {
                Scaffold.of(context).closeDrawer();
                if (isLoggedIn) {
                  await logoutWithFeedback(context);
                } else {
                  await ensureLoggedIn(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
