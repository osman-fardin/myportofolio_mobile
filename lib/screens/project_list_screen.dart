import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/screens/project_detail_screen.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});
  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  late Future<List<Project>> _future;
  @override
  void initState() {
    super.initState();
    _future = context.read<ApiClient>().getProjects();
  }

  Future<void> _reload() async {
    final next = context.read<ApiClient>().getProjects();
    setState(() {
      _future = next;
    });
    try {
      await next;
    } on ApiException {
      /* FutureBuilder renders the failure. */
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Proyek'),
      actions: [
        IconButton(
          onPressed: _reload,
          tooltip: 'Refresh proyek',
          icon: const Icon(Icons.refresh),
        ),
      ],
    ),
    drawer: const LeftDrawer(destination: PortfolioDestination.projects),
    body: FutureBuilder<List<Project>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final projects = snapshot.data ?? const <Project>[];
        return RefreshIndicator(
          onRefresh: _reload,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: snapshot.hasError
                ? [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Column(
                        children: [
                          Text(
                            snapshot.error is ApiException
                                ? (snapshot.error! as ApiException).message
                                : 'Proyek belum dapat dimuat.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _reload,
                            child: const Text('Coba lagi'),
                          ),
                        ],
                      ),
                    ),
                  ]
                : projects.isEmpty
                ? [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 64),
                      child: Text(
                        'Belum ada proyek.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]
                : projects
                      .map(
                        (project) => Card(
                          child: ListTile(
                            title: Text(project.title),
                            subtitle: Text(
                              '${project.projectType} · ${project.role}\n${project.technologies}\n${project.description}',
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () => Navigator.push<void>(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProjectDetailScreen(project: project),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
          ),
        );
      },
    ),
  );
}
