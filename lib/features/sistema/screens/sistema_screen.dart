import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sistema_provider.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_display.dart';

class SistemaScreen extends ConsumerWidget {
  const SistemaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sistema')),
      body: ListView(
        children: const [
          _SectionTile(title: 'Planes de Internet', icon: Icons.wifi),
          _PlanesSection(),
          Divider(),
          _SectionTile(title: 'Zonas', icon: Icons.map_outlined),
          _ZonasSection(),
          Divider(),
          _SectionTile(title: 'Routers', icon: Icons.router),
          _RoutersSection(),
        ],
      ),
    );
  }
}

class _SectionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionTile({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _PlanesSection extends ConsumerWidget {
  const _PlanesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(planesProvider).when(
          loading: () => const LoadingWidget(),
          error: (e, _) => ErrorDisplay(message: e.toString()),
          data: (planes) => Column(
            children: planes
                .map((p) => ListTile(
                      dense: true,
                      title: Text(p.nombre),
                      subtitle: Text(
                          '↓${p.velocidadBajada ?? '?'} / ↑${p.velocidadSubida ?? '?'}'),
                      trailing: p.precio != null
                          ? Text('\$${p.precio!.toStringAsFixed(2)}')
                          : null,
                    ))
                .toList(),
          ),
        );
  }
}

class _ZonasSection extends ConsumerWidget {
  const _ZonasSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(zonasProvider).when(
          loading: () => const LoadingWidget(),
          error: (e, _) => ErrorDisplay(message: e.toString()),
          data: (zonas) => Wrap(
            spacing: 8,
            runSpacing: 4,
            children: zonas
                .map((z) => Chip(label: Text(z.nombre)))
                .toList(),
          ),
        );
  }
}

class _RoutersSection extends ConsumerWidget {
  const _RoutersSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(routersProvider).when(
          loading: () => const LoadingWidget(),
          error: (e, _) => ErrorDisplay(message: e.toString()),
          data: (routers) => Column(
            children: routers
                .map((r) => ListTile(
                      dense: true,
                      leading: const Icon(Icons.router, size: 18),
                      title: Text(r.nombre),
                      subtitle: Text(r.ip ?? 'Sin IP'),
                      trailing: r.modelo != null ? Text(r.modelo!) : null,
                    ))
                .toList(),
          ),
        );
  }
}
