import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({required this.project, super.key});
  final Project project;
  @override
  Widget build(BuildContext context) {
    final image = context.read<ApiClient>().imageUrl(project);
    final details = {
      'Jenis proyek': project.projectType,
      'Peran': project.role,
      'Deskripsi': project.description,
      'Teknologi': project.technologies,
      'URL proyek': project.liveUrl,
      'Source code': project.sourceUrl.isEmpty
          ? 'Tidak diisi'
          : project.sourceUrl,
    };
    return Scaffold(
      appBar: AppBar(title: const Text('Detail proyek')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (image != null) ...[
                  Image.network(
                    image,
                    height: 220,
                    fit: BoxFit.cover,
                    semanticLabel: 'Gambar ${project.title}',
                    errorBuilder: (_, error, stack) => const SizedBox(
                      height: 100,
                      child: Center(child: Text('Gambar tidak tersedia.')),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                Text(
                  project.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                for (final entry in details.entries) ...[
                  Text(
                    entry.key,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 6),
                  SelectableText(entry.value),
                  const SizedBox(height: 24),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
